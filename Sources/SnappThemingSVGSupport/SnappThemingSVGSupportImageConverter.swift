//
//  SnappThemingSVGSupportImageConverter.swift
//  SnappThemingSVGSupport
//
//  Created by Oleksii Kolomiiets on 14.01.2025.
//

import Foundation
import OSLog
import SVGKit

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

/// A utility class for converts SVG data into a `UIImage`.
class SnappThemingSVGSupportImageConverter {
    #if canImport(UIKit)
        /// The rendered `UIImage` representation of the SVG data.
        private(set) var uiImage: UIImage
    #elseif canImport(AppKit)
        /// The rendered `NSImage` representation of the SVG data.
        private(set) var nsImage: NSImage
    #endif

    /// Initializes the `SnappThemingSVGSupportImageConverter` with the provided SVG data.
    ///
    /// - Parameter data: The SVG data to be rendered into a `UIImage`.
    /// - Note: If the SVG data is invalid or cannot be rendered, a default system image is used as a fallback.
    init(data: Data) {
        var svgImage: SVGKImage? = SVGKImage(data: data)

        // Retry logic for simulator or potential parsing issues
        // error: `*** Assertion failure in +[SVGLength pixelsPerInchForCurrentDevice], SVGLength.m:238`
        if svgImage == nil {
            os_log(.info, "Initial SVG parsing failed. Retrying...")
            svgImage = SVGKImage(data: data)
        }
        if let validSVGImage = svgImage {
            // Scale the SVG to a maximum size, maintaining its aspect ratio
            let targetSize = CGSize(
                width: max(validSVGImage.size.width, 512),
                height: max(validSVGImage.size.height, 512)
            )
            validSVGImage.scaleToFit(inside: targetSize)

            #if canImport(UIKit)
                // Attempt to render the scaled SVG into a UIImage
                if let renderedImage = validSVGImage.uiImage {
                    self.uiImage = renderedImage
                } else {
                    self.uiImage = Self.defaultFallbackImage
                    os_log(.error, "Failed to render SVG to UIImage after scaling. Using fallback image.")
                }
            #elseif canImport(AppKit)
                // Attempt to render the scaled SVG into a NSImage
                if let renderedImage = validSVGImage.nsImage {
                    self.nsImage = renderedImage
                } else {
                    self.nsImage = Self.defaultFallbackImage
                    os_log(.error, "Failed to render SVG to UIImage after scaling. Using fallback image.")
                }
            #endif
        } else {
            #if canImport(UIKit)
                self.uiImage = Self.defaultFallbackImage
            #elseif canImport(AppKit)
                self.nsImage = Self.defaultFallbackImage
            #endif
            os_log(.error, "Failed to parse SVG data after retry. Using fallback image.")
        }
    }

    #if canImport(UIKit)
        /// The default fallback image to use when SVG rendering fails.
        private static var defaultFallbackImage: UIImage {
            UIImage(systemName: "exclamationmark.triangle") ?? UIImage()
        }
    #elseif canImport(AppKit)
        /// The default fallback image to use when SVG rendering fails.
        private static var defaultFallbackImage: NSImage {
            NSImage(
                systemSymbolName: "exclamationmark.triangle",
                accessibilityDescription: "Missing image"
            ) ?? NSImage()
        }
    #endif
}
