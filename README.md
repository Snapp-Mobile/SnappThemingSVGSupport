# SnappThemingSVGSupport

<p align="center">
    <img src="Sources/SnappThemingSVGSupport/SnappThemingSVGSupport.docc/Resources/logo%402x.png">
    <br /><br />
    <a href="https://github.com/Snapp-Mobile/SnappThemingSVGSupport/tags" target="_blank"><img src="https://img.shields.io/github/v/tag/Snapp-Mobile/SnappThemingSVGSupport?color=yellow&label=version" alt="Latest Version"></a>
    <a href="https://github.com/Snapp-Mobile/SnappThemingSVGSupport/blob/main/LICENSE"><img src="https://img.shields.io/github/license/Snapp-Mobile/SnappThemingSVGSupport" alt="License Badge"></a>
    <br />
    <a href="https://img.shields.io/badge/swift--tools--version-6.0-red" target="_blank"><img src="https://img.shields.io/badge/swift--tools--version-6.0-red" alt="Swift Tools Version 6.0"></a>
    <a href="https://img.shields.io/badge/Platforms-_iOS_|_macOS_|_tvOS_-green" target="_blank"><img src="https://img.shields.io/badge/Platforms-_iOS_|_macOS_|_tvOS_-green" alt="Supported Platforms"></a>
<p/>
`SnappThemingSVGSupport` is a library that enables support for SVG asset handling in `SnappTheming`

Enabling the SVG support is as easy as adding one line to your codebase.

See the example below:

```swift
import SnappTheming
import SnappThemingSVGSupport

// in the app delegate or SwiftUI Application init
SnappThemingImageProcessorsRegistry.shared.register(.svg)
```

> The SVG support for `SnappTheming` is driven by [SVGKit](https://github.com/svgkit/svgkit). More information on `SnappTheming` can be found  [here](https://github.com/Snapp-Mobile/SnappTheming)
