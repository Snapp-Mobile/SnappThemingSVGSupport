//
//  SVGImageLoaderError.swift
//  SnappThemingSVGSupport
//
//  Created by Oleksii Kolomiiets on 11/6/25.
//

import Foundation

enum SVGImageLoaderError: Error, LocalizedError {
    case noJson(String)

    var errorDescription: String? {
        switch self {
        case .noJson(let string):
            return "Could not find \(string)"
        }
    }
}
