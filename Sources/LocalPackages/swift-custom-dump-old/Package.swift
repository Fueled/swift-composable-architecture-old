// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "swift-custom-dump-old",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "CustomDumpOld",
      targets: ["CustomDumpOld"]
    )
  ],
  dependencies: [
    .package(path: "../xctest-dynamic-overlay-old")
  ],
  targets: [
    .target(
      name: "CustomDumpOld",
      dependencies: [
        .product(name: "IssueReportingOld", package: "xctest-dynamic-overlay-old"),
        .product(name: "XCTestDynamicOverlayOld", package: "xctest-dynamic-overlay-old"),
      ],
      swiftSettings: [
        .enableExperimentalFeature("StrictConcurrency")
      ]
    ),
    .testTarget(
      name: "CustomDumpTests",
      dependencies: [
        "CustomDumpOld"
      ]
    ),
  ]
)
