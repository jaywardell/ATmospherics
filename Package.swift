// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ATmospherics",
    platforms: [
        .iOS(.v14),
        .macOS(.v13),
        .tvOS(.v14),
        .visionOS(.v1),
        .watchOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ATmospherics",
            targets: ["ATmospherics"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MasterJ93/ATProtoKit", from: "0.23.7"),
        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ATmospherics",
            dependencies: [
                "ATProtoKit"
            ]
        ),
        .testTarget(
            name: "ATmosphericsTests",
            dependencies: ["ATmospherics"]
        ),
    ]
)
