# SnappThemingSVGSupport

A library to provide support for SVG asset handling in [`SnappTheming`](https://github.com/Snapp-Mobile/SnappTheming)

## Overview

The SVG support is driven by [SVGKit](https://github.com/svgkit/svgkit)

To enable the SVG support all you need to do is to register the SVG image parser as follows:

```swift
import SnappTheming
import SnappThemingSVGSupport

// in the app delegate or SwiftUI Application init
SnappThemingImageProcessorsRegistry.shared.register(.svg)
```
