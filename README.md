# SnappThemingSVGSupport

<p align="center">
    <img src="Sources/SnappThemingSVGSupport/SnappThemingSVGSupport.docc/Resources/logo%402x.png">
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
