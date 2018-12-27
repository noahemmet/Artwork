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
		.package(url: "https://github.com/noahemmet/Common", .branch("master"))
    ],
    targets: [
        .target(
            name: "Artwork",
            dependencies: ["Common"],
            path: "Sources"),
        .testTarget(
            name: "ArtworkTests",
            dependencies: ["Artwork"],
            path: "Tests"),
    ]
)
