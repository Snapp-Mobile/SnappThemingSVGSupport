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
    @Test
    func testConverterSuccessfulConversionExpectedImage() throws {
        let expectedImageData = try #require(svgIconString.data(using: .utf8))
        let converter = SnappThemingSVGSupportImageConverter(data: expectedImageData)

        #expect(converter.image.size == CGSize(width: 24, height: 24))
    }

    @Test
    func testConverterSVGImageFailedFallbackImage() throws {
        let expectedImageData = try #require(svgIconString.data(using: .utf8))
        let converter = SnappThemingSVGSupportImageConverter(data: expectedImageData, svgImageType: MockSVGKImage.self)
        let fallbackImage: SnappThemingImage = try #require(.system("exclamationmark.triangle"))

        #expect(converter.image.size != CGSize(width: 24, height: 24))
        #if canImport(UIKit)
            #expect(converter.image == fallbackImage)
        #elseif canImport(AppKit)
            #expect(converter.image.tiffRepresentation == fallbackImage.tiffRepresentation)
        #endif
    }

    @Test
    func testConverterEmptyDataFallbackImage() async throws {
        let converter = SnappThemingSVGSupportImageConverter(data: Data())
        let fallbackImage: SnappThemingImage = try #require(.system("exclamationmark.triangle"))
        #if canImport(UIKit)
            #expect(converter.image == fallbackImage)
        #elseif canImport(AppKit)
            #expect(converter.image.tiffRepresentation == fallbackImage.tiffRepresentation)
        #endif
    }

    @Test
    func testConverterEmptyDataAndBrokenFallbackImage() async throws {
        let converter = SnappThemingSVGSupportImageConverter(data: Data(), fallbackImageName: "")
        let fallbackImage: SnappThemingImage = try #require(.system("exclamationmark.triangle"))
        #if canImport(UIKit)
            #expect(converter.image == SnappThemingImage())
        #elseif canImport(AppKit)
            #expect(converter.image.tiffRepresentation != fallbackImage.tiffRepresentation)
            #expect(converter.image.tiffRepresentation == nil)
        #endif
    }
}
