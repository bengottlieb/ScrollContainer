// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScrollContainer",
     platforms: [
              .macOS(.v14),
              .iOS(.v17),
              .watchOS(.v10)
         ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ScrollContainer",
            targets: ["ScrollContainer"]),
    ],
	 dependencies: [
		.package(url: "https://github.com/bengottlieb/suite", from: "1.0.98"),
	 ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "ScrollContainer", dependencies:  [
			.product(name: "Suite", package: "suite"),
		]),
    ]
)
