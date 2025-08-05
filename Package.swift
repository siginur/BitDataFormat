// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BitDataFormat",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BitDataFormat",
            targets: ["BitDataFormat"]),
    ],
    dependencies: [
        .package(url: "https://github.com/siginur/SMBitData.git", exact: "1.0.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BitDataFormat",
            dependencies: ["SMBitData"]
        ),
        .testTarget(
            name: "BitDataFormatTests",
            dependencies: ["BitDataFormat"],
//            resources: [.copy("all.json")],
        ),
    ]
)
