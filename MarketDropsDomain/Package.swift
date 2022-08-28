// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MarketDropsDomain",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "MarketDropsDomain",
            targets: ["MarketDropsDomain"]
        ),
        .library(
            name: "MarketDropsDomainFixtures",
            targets: ["MarketDropsDomainFixtures"]
        ),
    ],
    dependencies: [
        .package(path: "../MarketDropsCore"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MarketDropsDomain",
            dependencies: ["MarketDropsCore"]
        ),
        .target(
            name: "MarketDropsDomainFixtures",
            dependencies: ["MarketDropsDomain"]
        )
    ]
)
