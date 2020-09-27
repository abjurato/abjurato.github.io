// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fullScreenCover",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "fullScreenCover",
            targets: ["fullScreenCover"]),
    ],
    targets: [
        .target(
            name: "fullScreenCover",
            dependencies: []),
    ]
)
