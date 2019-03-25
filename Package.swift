// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FFFrankenstein",
    products: [
        .library(name: "FFFrankenstein", targets: ["FFFrankenstein"])
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.2.0")
    ],
    targets: [
        .target(name: "FFFrankenstein", dependencies: ["ShellOut"]),
    ]
)
