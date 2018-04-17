OGCircularBar
==================
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Circular progress bar for macOS.

This is a NSView subclass that lets you create beautiful circular progress bars.
Multiple bars can be added in one view, and styling options such as size, color and glow are available. Animatable.

![OGCircularBar for macOS](https://s3.amazonaws.com/cindori/images/circularbar.png "OGCircularBar for macOS")

## Installation (CocoaPods)
Configure your Podfile to use `OGCircularBar`:

```pod 'OGCircularBar'```

## Usage

Create an `OGCircularBarView` and add bars as such:

`barView.addBar(progress: 0.80, radius: 100, width: 10, color: NSColor.blue, animate: true, glow: true)`

You can add static circle backgrounds with the following method:

`barView.addCircleBar(radius: 80, width: 10, color: NSColor.purple.withAlphaComponent(0.2))`

## License
The MIT License (MIT)

Copyright (c) 2017 Oskar Groth

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
