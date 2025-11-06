//
//  SnappThemingSVGSupportSVGProcessorTests.swift
//  SnappThemingSVGSupport
//
//  Created by Oleksii Kolomiiets on 24.02.2025.
//

import Foundation
import SnappTheming
import Testing

@testable import SnappThemingSVGSupport

@Suite
struct SVGProcessorTests {
    let sut: SnappThemingSVGSupportSVGProcessor = .svg

    @Test
    func testSVGProcessorFail() {
        let object = SnappThemingImageObject(data: Data())
        #expect(sut.process(object, of: .png) == nil)
        #expect(sut.process(object, of: .jpeg) == nil)
        #expect(sut.process(object, of: .pdf) == nil)
        #expect(sut.process(object, of: .gif) == nil)
    }

    @Test
    func testSVGProcessorFallback() throws {
        let emptyStringData = try #require("".data(using: .utf8))
        let fallbackImage: SnappThemingImage = try #require(.system("exclamationmark.triangle"))
        let emptyStringDataObject = SnappThemingImageObject(data: emptyStringData)

        let emptyStringDataImage = try #require(sut.process(emptyStringDataObject, of: .svg))
        let emptyDataObject = SnappThemingImageObject(data: Data())
        let emptyDataImage = try #require(sut.process(emptyDataObject, of: .svg))

        #if canImport(UIKit)
            #expect(emptyStringDataImage == fallbackImage)
            #expect(emptyDataImage == fallbackImage)
        #elseif canImport(AppKit)
            #expect(emptyStringDataImage.tiffRepresentation == fallbackImage.tiffRepresentation)
            #expect(emptyDataImage.tiffRepresentation == fallbackImage.tiffRepresentation)
        #endif

    }

    @Test
    func testSVGProcessorExpectedImage() throws {
        let svgData = try #require(svgIconString.data(using: .utf8))
        let svgDataObject = SnappThemingImageObject(data: svgData)
        let processedIcon = try #require(sut.process(svgDataObject, of: .svg))

        #expect(processedIcon.size.width == 24)
        #expect(processedIcon.size.height == 24)
    }
}
