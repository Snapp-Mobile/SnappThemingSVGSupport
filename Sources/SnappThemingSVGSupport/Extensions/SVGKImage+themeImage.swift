//
//  SVGKImage+themeImage.swift
//  SnappThemingSVGSupport
//
//  Created by Oleksii Kolomiiets on 24.02.2025.
//

import SVGKit
import SnappTheming

extension SVGKImage {
    var themeImage: SnappThemingImage? {
        #if canImport(UIKit)
            self.uiImage
        #elseif canImport(AppKit)
            self.nsImage
        #endif
    }
}
