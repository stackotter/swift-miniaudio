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
            dependencies: [
                .target(
                    name: "MiniAudioC",
                    condition: .when(platforms: [
                        .macOS, .windows, .linux, .android, .wasi
                    ])
                ),
                .target(
                    name: "MiniAudioObjC",
                    condition: .when(platforms: [
                        .macCatalyst, .iOS, .tvOS, .visionOS, .watchOS
                    ])
                )
            ]
        ),
        .target(
            name: "MiniAudioC",
            exclude: ["impl.m"],
            cSettings: [.define("MINIAUDIO_IMPLEMENTATION")]
        ),
        .target(
            name: "MiniAudioObjC",
            path: "Sources/MiniAudioC",
            exclude: ["impl.c"],
            cSettings: [.define("MINIAUDIO_IMPLEMENTATION")]
        ),
        .executableTarget(
            name: "Example",
            dependencies: ["MiniAudio"],
            resources: [.copy("Audio/loop.mp3")]
        ),
        .testTarget(
            name: "MiniAudioTests",
            dependencies: ["MiniAudio"]
        ),
    ]
)
