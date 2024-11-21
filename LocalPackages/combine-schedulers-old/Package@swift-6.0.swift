// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "combine-schedulers-old",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "CombineSchedulersOld",
      targets: ["CombineSchedulersOld"]
    )
  ],
  dependencies: [
    .package(path: "../swift-concurrency-extras-old"),
    .package(path: "../xctest-dynamic-overlay-old"),
  ],
  targets: [
    .target(
      name: "CombineSchedulersOld",
      dependencies: [
        .product(name: "ConcurrencyExtrasOld", package: "swift-concurrency-extras-old"),
        .product(name: "IssueReportingOld", package: "xctest-dynamic-overlay-old"),
      ]
    ),
    .testTarget(
      name: "CombineSchedulersTests",
      dependencies: [
        "CombineSchedulersOld"
      ]
    ),
  ],
  swiftLanguageModes: [.v6]
)