//
//  SVGParser.swift
//  SnappThemingSVGSupport
//
//  Created by Oleksii Kolomiiets on 15.01.2025.
//

import Foundation
import OSLog
import SVGKit
import SnappTheming
import UniformTypeIdentifiers

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

/// Extension for `SnappThemingExternalImageProcessorProtocol` to provide a default implementation for SVG processing.
extension SnappThemingExternalImageProcessorProtocol where Self == SnappThemingSVGSupportSVGProcessor {
    /// Provides a static instance of `SnappThemingSVGSupportSVGProcessor`.
    ///
    /// - Returns: A new instance of `SnappThemingSVGSupportSVGProcessor` to handle `.svg` image processing.
    public static var svg: SnappThemingSVGSupportSVGProcessor { SnappThemingSVGSupportSVGProcessor() }
}

/// A processor for handling SVG image data, conforming to `SnappThemingExternalImageProcessorProtocol`.
public struct SnappThemingSVGSupportSVGProcessor: SnappThemingExternalImageProcessorProtocol {
    #if canImport(UIKit)
        /// Processes the provided image data and type and converts it into a `UIImage` if the type is `.svg`.
        ///
        /// - Parameter data: Image `Data`.
        /// - Parameter type: Image `UTType`.
        /// - Returns: A `UIImage` if the processing and conversion are successful; otherwise, `nil`.
        ///
        /// - Note: This method specifically handles `.svg` type. If the type does not match, the method returns `nil`.
        /// - Warning: Ensure that the `data` is valid SVG data to avoid potential rendering issues.
        public func process(_ data: Data, of type: UTType) -> UIImage? {
            guard type == .svg else {
                os_log(.error, "Invalid type provided: %{public}@. Only .svg type is supported.", "\(type)")
                return nil
            }

            let uiImage = SnappThemingSVGSupportImageConverter(data: data).uiImage

            return uiImage
        }
    #elseif canImport(AppKit)
        /// Processes the provided image data and type and converts it into a `NSImage` if the type is `.svg`.
        ///
        /// - Parameter data: Image `Data`.
        /// - Parameter type: Image `UTType`.
        /// - Returns: A `NSImage` if the processing and conversion are successful; otherwise, `nil`.
        ///
        /// - Note: This method specifically handles `.svg` type. If the type does not match, the method returns `nil`.
        /// - Warning: Ensure that the `data` is valid SVG data to avoid potential rendering issues.
        public func process(_ data: Data, of type: UTType) -> NSImage? {
            guard type == .svg else {
                os_log(.error, "Invalid type provided: %{public}@. Only .svg type is supported.", "\(type)")
                return nil
            }

            let nsImage = SnappThemingSVGSupportImageConverter(data: data).nsImage

            return nsImage
        }
    #endif

    /// Initializes the `SnappThemingSVGSupportSVGProcessor`.
    ///
    /// This default initializer is used to create instances of the processor for processing SVG data.
    public init() {}
}
