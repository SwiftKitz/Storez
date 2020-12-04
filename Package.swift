// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Storez",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_12),
        .tvOS(.v9),
        .watchOS(.v4),
    ],
    products: [
        .library(
            name: "Storez",
            targets: ["Storez"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Storez",
            dependencies: []),
        .testTarget(
            name: "StorezTests",
            dependencies: ["Storez"]),
    ]
)
