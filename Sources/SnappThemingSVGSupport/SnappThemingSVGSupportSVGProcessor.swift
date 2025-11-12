//
//  SVGParser.swift
//  SnappThemingSVGSupport
//
//  Created by Oleksii Kolomiiets on 15.01.2025.
//

import Foundation
import OSLog
import SnappTheming
import UniformTypeIdentifiers

/// Extension for `SnappThemingExternalImageProcessorProtocol` to provide a default implementation for SVG processing.
extension SnappThemingExternalImageProcessorProtocol where Self == SnappThemingSVGSupportSVGProcessor {
    /// Provides a static instance of `SnappThemingSVGSupportSVGProcessor`.
    ///
    /// - Returns: A new instance of `SnappThemingSVGSupportSVGProcessor` to handle `.svg` image processing.
    public static var svg: SnappThemingSVGSupportSVGProcessor { SnappThemingSVGSupportSVGProcessor() }
}

/// A processor for handling SVG image data, conforming to `SnappThemingExternalImageProcessorProtocol`.
public struct SnappThemingSVGSupportSVGProcessor: SnappThemingExternalImageProcessorProtocol {
    private let converter: SnappThemingSVGSupportImageConverter

    /// Processes image data and converts it to a `SnappThemingImage` for SVG types.
    ///
    /// This method handles SVG image conversion by delegating to the internal converter.
    /// For non-SVG types, the method returns `nil` and logs an error.
    ///
    /// - Parameters:
    ///   - object: The image object containing the SVG data to process.
    ///   - type: The uniform type identifier for the image. Only `.svg` is supported.
    ///
    /// - Returns: A `SnappThemingImage` if the input is valid SVG data; otherwise, `nil`.
    ///
    /// ## Platform Availability
    /// - On **iOS**, **iPadOS**, **tvOS**, **watchOS**, and **visionOS**: `SnappThemingImage` is a type alias for `UIImage`.
    /// - On **macOS**: `SnappThemingImage` is a type alias for `NSImage`.
    ///
    /// ## Supported Types
    /// Only `.svg` type is supported. Providing any other type will result in `nil` and an error log.
    ///
    /// - Warning: Ensure the provided data is valid SVG to prevent rendering issues.
    ///
    /// ## Example
    /// ```swift
    /// let svgObject = SnappThemingImageObject(data: svgData)
    /// if let image = processor.process(svgObject, of: .svg) {
    ///     imageView.image = image
    /// }
    /// ```
    public func process(_ object: SnappThemingImageObject, of type: UTType) -> SnappThemingImage? {
        guard type == .svg else {
            os_log(.error, "Invalid type provided: %{public}@. Only .svg type is supported.", "\(type)")
            return nil
        }

        return converter.convert(object)
    }

    /// Initializes the `SnappThemingSVGSupportSVGProcessor`.
    ///
    /// This default initializer is used to create instances of the processor for processing SVG data.
    public init() {
        converter = SnappThemingSVGSupportImageConverter()
    }
}
