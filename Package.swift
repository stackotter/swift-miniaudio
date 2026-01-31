// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "MiniAudio",
    products: [
        .library(
            name: "MiniAudio",
            targets: ["MiniAudio"]
        ),
    ],
    targets: [
        .target(
            name: "MiniAudio",
            dependencies: ["MiniAudioC"]
        ),
        .target(
            name: "MiniAudioC",
            cSettings: [.define("MINIAUDIO_IMPLEMENTATION")]
        ),
        .executableTarget(
            name: "Example",
            dependencies: ["MiniAudio"],
            resources: [.copy("loop.mp3")]
        ),
        .testTarget(
            name: "MiniAudioTests",
            dependencies: ["MiniAudio"]
        ),
    ]
)
