// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Pentagram",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "Pentagram",
            targets: ["Pentagram"]
        ),
    ],
    targets: [
        .target(
            name: "Pentagram",
            path: "Pentagram/Sources/",
            publicHeadersPath: "Pentagram/Sources/*.h"
        ),
    ],
    swiftLanguageVersions: [.version("6.1")]
)
