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

/// A utility class for converts SVG data into a `SnappThemingImage`.
final class SnappThemingSVGSupportImageConverter: Sendable {
    /// Initializes the `SnappThemingSVGSupportImageConverter` with the provided SVG data.
    ///
    /// - Parameters:
    ///   - object: The object of `SnappThemingImageObject` type to contain SVG image data and file url if available.
    ///   - svgImageType: The type used for SVG rendering, defaulting to `SVGKImage.self`.
    ///   - fallbackImageName: The system image name used as a fallback if the SVG data is invalid or cannot be rendered.
    ///
    /// - Note: If the SVG data is invalid or rendering fails, a system image with the name specified in `fallbackImageName`
    ///   (default: `"exclamationmark.triangle"`) will be used instead.
    func convert(
        _ object: SnappThemingImageObject,
        ofType svgImageType: SVGKImage.Type = SVGKImage.self,
        withFallback fallbackImageName: String = "exclamationmark.triangle"
    ) -> SnappThemingImage {
        let svgImage: SVGKImage?

        if let url = object.url {
            svgImage = prepareSVGImage(using: url, svgImageType: svgImageType)
        } else {
            svgImage = prepareSVGImage(using: object.data, svgImageType: svgImageType)
        }

        if let validSVGImage = svgImage {
            if let renderedImage = validSVGImage.themeImage {
                return renderedImage
            } else {
                os_log(.error, "Failed to render SVG to UIImage. Using fallback image.")
                return Self.defaultFallbackImage(fallbackImageName)
            }
        } else {
            os_log(.error, "Failed to parse SVG data after retry. Using fallback image.")
            return Self.defaultFallbackImage(fallbackImageName)
        }
    }

    /// The default fallback image to use when SVG rendering fails.
    private static func defaultFallbackImage(_ name: String) -> SnappThemingImage {
        .system(name) ?? SnappThemingImage()
    }

    private func prepareSVGImage(using url: URL, svgImageType: SVGKImage.Type) -> SVGKImage? {
        // Retry logic for simulator or potential parsing issues
        // error: `*** Assertion failure in +[SVGLength pixelsPerInchForCurrentDevice], SVGLength.m:238`
        // First attempt may fail with PPI assertion, but retry succeeds due to UIScreen initialization
        svgImageType.init(contentsOfFile: url.path()) ?? svgImageType.init(contentsOfFile: url.path())
    }

    private func prepareSVGImage(using data: Data, svgImageType: SVGKImage.Type) -> SVGKImage? {
        // Retry logic for simulator or potential parsing issues
        // error: `*** Assertion failure in +[SVGLength pixelsPerInchForCurrentDevice], SVGLength.m:238`
        // First attempt may fail with PPI assertion, but retry succeeds due to UIScreen initialization
        svgImageType.init(data: data) ?? svgImageType.init(data: data)
    }
}
