# ``SnappThemingSVGSupport``

@Metadata {
    @PageImage(purpose: icon, source:"logo")
    @PageColor(gray)
}

Enables support for SVG asset handling in `SnappTheming`

## Overview

Enabling the SVG support is as easy as adding one line to your codebase. It extends [SnppTheming](https://github.com/Snapp-Mobile/SnappTheming) functionality.

## Usage

```swift
import SnappTheming
import SnappThemingSVGSupport

// in the app delegate or SwiftUI Application init
let svg: SnappThemingSVGSupportSVGProcessor = .svg
SnappThemingImageProcessorsRegistry.shared.register(.svg)

// in case it needed processor can be unregistered
SnappThemingImageProcessorsRegistry.shared.unregister(SnappThemingSVGSupportSVGProcessor.self)
```

[Clone on GitHub](https://github.com/Snapp-Mobile/SnappThemingSVGSupport)

> The SVG support for `SnappTheming` is driven by [SVGKit](https://github.com/svgkit/svgkit). More information on `SnappTheming` can be found  [here](https://ios-theming.snappmobile.io/documentation/snapptheming)

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
