// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Artwork",
    products: [
        .library(
            name: "Artwork",
            targets: ["Artwork"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent-sqlite.git", .exact("3.0.0")),
        .package(path: "../Common")
    ],
    targets: [
        .target(
            name: "Artwork",
            dependencies: ["FluentSQLite", "Common"],
            path: "Sources"),
        .testTarget(
            name: "ArtworkTests",
            dependencies: ["Artwork"],
            path: "Tests"),
    ]
)
