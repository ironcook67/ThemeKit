// Package.swift
// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ThemeKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
        .tvOS(.v18),
        .watchOS(.v10),
        .visionOS(.v2)
    ],
    products: [
        .library(
            name: "ThemeKit",
            targets: ["ThemeKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ironcook67/ColorKit.git", from: "1.1.1")
    ],
    targets: [
        .target(
            name: "ThemeKit",
            dependencies: ["ColorKit"],
        ),
//        .testTarget(
//            name: "ThemeKitTests",
//            dependencies: ["ThemeKit"],
//        ),
    ]
)
