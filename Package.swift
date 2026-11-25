// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "JonAlert",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "JonAlert", targets: ["JonAlert"])
    ],
    targets: [
        .target(name: "JonAlert"),
        .testTarget(name: "JonAlertTests", dependencies: ["JonAlert"])
    ]
)
