//
//  MockSVGKImage.swift
//  SnappThemingSVGSupport
//
//  Created by Oleksii Kolomiiets on 24.02.2025.
//

import SVGKit

final class MockSVGKImage: SVGKImage {
    #if canImport(UIKit)
        override var uiImage: UIImage! {
            return nil
        }
    #elseif canImport(AppKit)
        override var nsImage: NSImage! {
            return nil
        }
    #endif
}
