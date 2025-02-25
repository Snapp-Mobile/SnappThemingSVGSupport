//
//  SnappThemingSVGSupportImageConverter.swift
//  SnappThemingSVGSupport
//
//  Created by Oleksii Kolomiiets on 14.01.2025.
//

import Foundation
import OSLog
import SVGKit
import SnappTheming

/// A utility class for converts SVG data into a `UIImage`.
final class SnappThemingSVGSupportImageConverter {
    /// The rendered `UIImage` representation of the SVG data.
    private(set) var image: SnappThemingImage

    /// Initializes the `SnappThemingSVGSupportImageConverter` with the provided SVG data.
    ///
    /// - Parameters:
    ///   - data: The SVG data to be rendered into a `SnappThemingImage`.
    ///   - svgImageType: The type used for SVG rendering, defaulting to `SVGKImage.self`.
    ///   - fallbackImageName: The system image name used as a fallback if the SVG data is invalid or cannot be rendered.
    ///
    /// - Note: If the SVG data is invalid or rendering fails, a system image with the name specified in `fallbackImageName`
    ///   (default: `"exclamationmark.triangle"`) will be used instead.
    init(
        data: Data,
        svgImageType: SVGKImage.Type = SVGKImage.self,
        fallbackImageName: String = "exclamationmark.triangle"
    ) {
        var svgImage: SVGKImage? = svgImageType.init(data: data)

        // Retry logic for simulator or potential parsing issues
        // error: `*** Assertion failure in +[SVGLength pixelsPerInchForCurrentDevice], SVGLength.m:238`
        if svgImage == nil {
            os_log(.info, "Initial SVG parsing failed. Retrying...")
            svgImage = svgImageType.init(data: data)
        }

        if let validSVGImage = svgImage {
            if let renderedImage = validSVGImage.themeImage {
                self.image = renderedImage
            } else {
                self.image = Self.defaultFallbackImage(fallbackImageName)
                os_log(.error, "Failed to render SVG to UIImage. Using fallback image.")
            }
        } else {
            self.image = Self.defaultFallbackImage(fallbackImageName)
            os_log(.error, "Failed to parse SVG data after retry. Using fallback image.")
        }
    }

    /// The default fallback image to use when SVG rendering fails.
    private static func defaultFallbackImage(_ name: String) -> SnappThemingImage {
        .system(name) ?? SnappThemingImage()
    }
}
