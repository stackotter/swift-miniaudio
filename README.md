## swift-miniaudio

A thin wrapper around [miniaudio](https://github.com/mackron/miniaudio).

Tested on macOS, Linux, and Windows. Should work on iOS and Android as well (in theory).

> [!WARNING]
> This library is still very rudimentary and only provides bindings for the core
> audio playback features required to create SwiftCrossUI's MusicPlayerExample
> app. It may be a while before I get back to working on this library, but
> contributions are welcome as always!

### What is miniaudio?

> An audio playback and capture library in a single source file.
>
> miniaudio is written in C with no dependencies except the standard library and should compile clean on all major compilers without the need to install any additional development packages. All major desktop and mobile platforms are supported.

### Usage

```swift
import Foundation
import MiniAudio

let file = URL(/* ... */)
let engine = try Engine()
let sound = try engine.loadSound(file)
try sound.start()

Foundation.sleep(/* ... */)
```
