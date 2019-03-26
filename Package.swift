// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FFFrankenstein",
    platforms: [.macOS(.v10_12)],
//    providers: [.brew(["varenc/ffmpeg/ffmpeg"])],
    products: [.library(name: "FFFrankenstein", targets: ["FFFrankenstein"])],
    dependencies: [.package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.2.0")],
    targets: [.target(name: "FFFrankenstein", dependencies: ["ShellOut"])],
    swiftLanguageVersions: [.v5]
)
