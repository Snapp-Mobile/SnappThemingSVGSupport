//
//  SVGImageLoader.swift
//  ExampleApp
//
//  Created by Oleksii Kolomiiets on 11/4/25.
//

import Combine
import SnappTheming
import SnappThemingSVGSupport
import SwiftUI

class SVGImageLoader: ObservableObject {
    @Published var currentTheme: Theme

    init(_ currentTheme: Theme = .light) {
        self.currentTheme = currentTheme
    }

    func toggleImage() throws -> Image {
        return try loadImage(from: currentTheme.next())
    }

    func loadImage(
        from theme: Theme,
        withExtension ext: String = "json"
    ) throws -> Image {
        #if SWIFT_PACKAGE
            let bundle = Bundle.module
        #else
            let bundle = Bundle.main
        #endif

        // TODO: iOS simulator executable target fails with Bundle.module:
        // "failure in void __BKSHIDEvent__BUNDLE_IDENTIFIER_FOR_CURRENT_PROCESS_IS_NIL__"
        // Works correctly when package is built as library target (macOS)

        guard let url = bundle.url(forResource: theme.rawValue, withExtension: ext) else {
            throw SVGImageLoaderError.noJson("\(theme).\(ext)")
        }

        print(url)
        currentTheme = theme

        let jsonData = try Data(contentsOf: url)
        let json = String(data: jsonData, encoding: .utf8) ?? ""
        let declaration = try SnappThemingParser.parse(from: json)

        let icon = declaration.images.svg
        return icon
    }
}
