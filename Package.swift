// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SnappThemingSVGSupport",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "SnappThemingSVGSupport",
            targets: ["SnappThemingSVGSupport"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SVGKit/SVGKit.git", from: "3.0.0"),
        .package(url: "https://github.com/Snapp-Mobile/SnappTheming", from: "0.1.2"),
        .package(url: "https://github.com/Snapp-Mobile/SwiftFormatLintPlugin.git", exact: "1.0.4"),
    ],
    targets: [
        .target(
            name: "SnappThemingSVGSupport",
            dependencies: [
                "SVGKit",
                "SnappTheming",
            ],
            plugins: [
                .plugin(name: "Lint", package: "SwiftFormatLintPlugin")
            ]
        ),
        .testTarget(
            name: "SnappThemingSVGSupportTests",
            dependencies: [
                "SVGKit",
                "SnappTheming",
                "SnappThemingSVGSupport",
            ],
            resources: [
                .copy("Resources/images.json")
            ]
        ),

    ]
)
