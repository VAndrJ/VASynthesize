// swift-tools-version: 6.0

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "VASynthesize",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "VASynthesize",
            targets: ["VASynthesize"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.0-latest"),
    ],
    targets: [
        .macro(
            name: "VASynthesizeMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "VASynthesize", dependencies: ["VASynthesizeMacros"]),
        .executableTarget(name: "VASynthesizeClient", dependencies: ["VASynthesize"]),
        .testTarget(
            name: "VASynthesizeTests",
            dependencies: [
                "VASynthesizeMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
