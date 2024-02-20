// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "p1-ios",
    products: [
        .library(name: "P1Package", targets: ["P1Package", "FaceTecSDK"]),
    ],
    targets: [
        .target(name: "P1Package"),
        .testTarget(name: "P1PackageTests", dependencies: ["P1Package"]),
        .binaryTarget(name: "FaceTecSDK", path: "FaceTecSDK.xcframework"),
    ]
)
