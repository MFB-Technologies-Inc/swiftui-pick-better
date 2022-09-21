// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "swiftui-pick-better",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .watchOS(.v7),
        .tvOS(.v14),
    ],
    products: [
        .library(
            name: "PickBetter",
            targets: ["PickBetter"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(name: "PickBetter"),
    ]
)
