// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FFrankenstein",
    products: [.library(name: "FFrankenstein", targets: ["FFrankenstein"])],
    dependencies: [.package(url: "https://github.com/JohnSundell/Files.git", from: "2.2.1")],
    targets: [.target(name: "FFrankenstein", dependencies: ["Files"])]
)
