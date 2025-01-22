//
//  ParserTests.swift
//  SnappThemingSVGSupport
//
//  Created by Ilian Konchev on 22.01.25.
//

import SVGKit
import Testing

@testable import SnappTheming
@testable import SnappThemingSVGSupport

@Suite
struct ParserTests {
    @Test
    func testSVGImageParser() throws {
        let url = try #require(
            Bundle.module.url(forResource: "images", withExtension: "json"), "Images JSON should be present")

        let jsonData = try Data(contentsOf: url)
        let json = try #require(String(data: jsonData, encoding: .utf8), "JSON should be readable")

        SnappThemingImageProcessorsRegistry.shared.register(.svg)

        let declaration = try SnappThemingParser.parse(from: json)
        #expect(declaration.images.cache.count == 1)
        let representation = try #require(declaration.images.cache["svgImage"]?.value)
        #expect(representation.data != nil)
    }
}
