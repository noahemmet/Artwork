// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Artwork",
	platforms: [
		.iOS(.v13)
	],
	products: [
		.library(
			name: "Artwork",
			targets: ["Artwork"]),
	],
    dependencies: [
		.package(url: "https://github.com/noahemmet/Common", .branch("spm"))
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
