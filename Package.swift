// swift-tools-version:6.0

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
            resources: [.copy("PrivacyInfo.xcprivacy")],
            swiftSettings: [.swiftLanguageMode(.v6)]),
        .testTarget(
            name: "StorezTests",
            dependencies: ["Storez"],
            swiftSettings: [.swiftLanguageMode(.v6)]),
    ]
)
