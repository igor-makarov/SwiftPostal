// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftPostal",
    products: [
        .executable(
            name: "SwiftPostal",
            targets: ["CLI"]),
        .library(
            name: "SwiftPostalFramework",
            targets: ["SwiftPostal"]),
        ],
    dependencies: [
        .package(url: "https://github.com/igor-makarov/Clibpostal.git", .branch("master")),
        .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0")
    ],
    targets: [
        .target(name: "SwiftPostal"),
        .target(name: "CLI",
                dependencies: [
                    "SwiftPostal",
                    "Commander"
            ]),
        .target(name: "ProfilerHelper",
                dependencies: [
                    "SwiftPostal"
            ]),
        .testTarget(name: "SwiftPostalTests",
                    dependencies: [
                        "SwiftPostal"
            ]),
        ]
)
