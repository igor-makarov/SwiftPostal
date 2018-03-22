// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftPostal",
    products: [
        .executable(
            name: "SwiftPostal.CLI",
            targets: ["SwiftPostal.CLI"]),
        .library(
            name: "SwiftPostal",
            targets: ["SwiftPostal"]),
        ],
    dependencies: [
        .package(url: "https://github.com/igor-makarov/Clibpostal.git", .branch("master")),
        .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0")
    ],
    targets: [
        .target(name: "SwiftPostal"),
        .target(name: "SwiftPostal.CLI",
                dependencies: [
                    "SwiftPostal",
                    "Commander"
            ]),
        .target(name: "SwiftPostal.ProfilerHelper",
                dependencies: [
                    "SwiftPostal"
            ]),
        .testTarget(name: "SwiftPostal.Tests",
                    dependencies: [
                        "SwiftPostal"
            ]),
        ]
)
