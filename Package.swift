// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FFrankenstein",
    products: [
        .library(name: "FFrankenstein", targets: ["FFrankenstein"]),
        .executable(name: "GraveYard", targets: ["GraveYard"])
    ],
    dependencies: [
        .package(url: "https://github.com/mxcl/Path.swift.git", from: "0.15.4"),
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", from: "0.13.0")
    ],
    targets: [
        .target(name: "FFrankenstein", dependencies: ["Path", "SDGExternalProcess"]),
        .target(name: "GraveYard", dependencies: ["FFrankenstein"])
    ]
)
