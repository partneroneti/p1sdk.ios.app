// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "p1-ios",
    products: [
        .library(name: "PartnerOneSDK", targets: ["PartnerOneSDK", "FaceTecSDK"]),
    ],
    targets: [
        .target(name: "PartnerOneSDK"),
        .testTarget(name: "PartnerOneSDKTests", dependencies: ["PartnerOneSDK"]),
        .binaryTarget(name: "FaceTecSDK", path: "FaceTecSDK.xcframework"),
    ]
)
