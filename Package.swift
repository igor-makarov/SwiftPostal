// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftPostal",
    products: [
        .library(
            name: "SwiftPostal",
            targets: ["SwiftPostal"]),
    ],
    dependencies: [
        .package(url: "https://github.com/igor-makarov/Clibpostal.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "SwiftPostal",
            dependencies: []),
        .testTarget(
            name: "SwiftPostalTests",
            dependencies: ["SwiftPostal"]),
    ]
)
