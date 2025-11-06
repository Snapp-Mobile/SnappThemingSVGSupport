//
//  ContentView.swift
//  ExampleApp
//
//  Created by Oleksii Kolomiiets on 11/4/25.
//

import OSLog
import SnappTheming
import SnappThemingSVGSupport
import SwiftUI

struct ContentView: View {
    @StateObject private var imageLoader = SVGImageLoader()
    @State private var loadError: Error?
    @State private var image: Image?

    var body: some View {
        VStack(spacing: 32) {
            Text("\(imageLoader.currentTheme.rawValue).json")
                .font(.title2)
                .fontWeight(.bold)

            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .id(UUID())
            } else if let error = loadError {
                Text("Error: \(error.localizedDescription)")
                    .font(.caption)
                    .foregroundColor(.red)
            } else {
                ProgressView()
            }

            Button(action: toggleTheme) {
                Text("toggle")
            }
            .buttonStyle(.borderedProminent)

            Text("This example demonstrates SnappThemingSVGSupport theme switching capabilities.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .onAppear {
            loadTheme()
        }
    }

    private func loadTheme() {
        do {
            image = try imageLoader.loadImage(from: .light)
            loadError = nil
        } catch {
            loadError = error
            os_log(.fault, "Image loading error: %{public}@", error.localizedDescription)
        }
    }

    private func toggleTheme() {
        do {
            image = try imageLoader.toggleImage()
            loadError = nil
        } catch {
            loadError = error
            os_log(.fault, "Image toggling error: %{public}@", error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
