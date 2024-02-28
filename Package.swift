// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "p1-ios",
    defaultLocalization: "pt",
    products: [
        .library(name: "PartnerOneSDK", targets: ["PartnerOneSDK", "FaceTecSDK"]),
    ],
    targets: [
        .target(name: "PartnerOneSDK", resources: [
                .process("Classes/FaceTecFiles/FaceTec.strings"),
                .process("Fonts.xcassets"),
                .process("Assets/Fonts/SFProDisplay-Regular.ttf")
            ]
        ),
        .testTarget(name: "PartnerOneSDKTests", dependencies: ["PartnerOneSDK"]),
        .binaryTarget(name: "FaceTecSDK", path: "FaceTecSDK.xcframework"),
    ]
)
