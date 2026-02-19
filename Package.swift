// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Storez",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
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
            dependencies: [],
            resources: [.copy("PrivacyInfo.xcprivacy")]),
        .testTarget(
            name: "StorezTests",
            dependencies: ["Storez"]),
    ]
)
