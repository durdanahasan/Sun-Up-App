// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SunUp",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [.library(name: "SunUpCore", targets: ["SunUpCore"])],
    targets: [
        .target(name: "SunUpCore"),
        .testTarget(name: "SunUpCoreTests", dependencies: ["SunUpCore"])
    ]
)
