// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FloatingNavKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "FloatingNavKit", targets: ["FloatingNavKit"])
    ],
    targets: [
        .target(name: "FloatingNavKit")
    ]
)
