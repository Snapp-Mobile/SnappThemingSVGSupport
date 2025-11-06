//
//  Test.swift
//  SnappThemingSVGSupport
//
//  Created by Oleksii Kolomiiets on 24.02.2025.
//

import Foundation
import SnappTheming
import Testing

@testable import SnappThemingSVGSupport

@Suite
struct ImageConverterTests {
    private let converter = SnappThemingSVGSupportImageConverter()

    @Test
    func testConverterSuccessfulConversionExpectedImage() throws {
        let expectedImageData = try #require(svgIconString.data(using: .utf8))
        let object = SnappThemingImageObject(data: expectedImageData)
        let image = converter.convert(object)

        #expect(image.size == CGSize(width: 24, height: 24))
    }

    @Test
    func testConverterSVGImageFailedFallbackImage() throws {
        let expectedImageData = try #require(svgIconString.data(using: .utf8))
        let object = SnappThemingImageObject(data: expectedImageData)
        let image = converter.convert(object, ofType: MockSVGKImage.self)
        let fallbackImage: SnappThemingImage = try #require(.system("exclamationmark.triangle"))

        #expect(image.size != CGSize(width: 24, height: 24))
        #if canImport(UIKit)
            #expect(image == fallbackImage)
        #elseif canImport(AppKit)
            #expect(image.tiffRepresentation == fallbackImage.tiffRepresentation)
        #endif
    }

    @Test
    func testConverterEmptyDataFallbackImage() async throws {
        let object = SnappThemingImageObject(data: Data())
        let image = converter.convert(object)
        let fallbackImage: SnappThemingImage = try #require(.system("exclamationmark.triangle"))
        #if canImport(UIKit)
            #expect(image == fallbackImage)
        #elseif canImport(AppKit)
            #expect(image.tiffRepresentation == fallbackImage.tiffRepresentation)
        #endif
    }

    @Test
    func testConverterEmptyDataAndBrokenFallbackImage() async throws {
        let object = SnappThemingImageObject(data: Data())
        let image = converter.convert(object, withFallback: "")
        let fallbackImage: SnappThemingImage = try #require(.system("exclamationmark.triangle"))
        #if canImport(UIKit)
            #expect(image == SnappThemingImage())
        #elseif canImport(AppKit)
            #expect(image.tiffRepresentation != fallbackImage.tiffRepresentation)
            #expect(image.tiffRepresentation == nil)
        #endif
    }
}
