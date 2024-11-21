// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "swift-snapshot-testing-old",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "SnapshotTestingOld",
      targets: ["SnapshotTestingOld"]
    ),
    .library(
      name: "InlineSnapshotTestingOld",
      targets: ["InlineSnapshotTestingOld"]
    ),
  ],
  dependencies: [
    .package(path: "../swift-syntax-old"),
  ],
  targets: [
    .target(
      name: "SnapshotTestingOld"
    ),
    .target(
      name: "InlineSnapshotTestingOld",
      dependencies: [
        "SnapshotTestingOld",
        .product(name: "SwiftParserOld", package: "swift-syntax-old"),
        .product(name: "SwiftSyntaxOld", package: "swift-syntax-old"),
        .product(name: "SwiftSyntaxBuilderOld", package: "swift-syntax-old"),
      ]
    ),
    .testTarget(
      name: "InlineSnapshotTestingTests",
      dependencies: [
        "InlineSnapshotTestingOld"
      ]
    ),
    .testTarget(
      name: "SnapshotTestingTests",
      dependencies: [
        "SnapshotTestingOld"
      ],
      exclude: [
        "__Fixtures__",
        "__Snapshots__",
      ]
    ),
  ]
)
