//
//  Theme.swift
//  SnappThemingSVGSupport
//
//  Created by Oleksii Kolomiiets on 11/6/25.
//

import Foundation

enum Theme: String {
    case light, dark, pink

    func next() -> Self {
        switch self {
        case .light: .dark
        case .dark: .pink
        case .pink: .light
        }
    }
}
