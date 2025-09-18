// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftSVG",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "SwiftSVG",
            targets: ["SwiftSVG"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "SwiftSVG",
            dependencies: [],
            path: "Sources"
        )
    ]
)