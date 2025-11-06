//
//  ExampleApp.swift
//  ExampleApp
//
//  Created by Oleksii Kolomiiets on 11/4/25.
//

import SnappTheming
import SnappThemingSVGSupport
import SwiftUI

@main
struct ExampleApp: App {
    @State private var isDarkMode = false

    init() {
        SnappThemingImageProcessorsRegistry.shared.register(.svg)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
