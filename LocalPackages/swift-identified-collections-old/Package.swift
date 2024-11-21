// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "swift-identified-collections-old",
  products: [
    .library(
      name: "IdentifiedCollectionsOld",
      targets: ["IdentifiedCollectionsOld"]
    )
  ],
  dependencies: [
    .package(path: "../swift-collections-old"),
    .package(path: "../swift-collections-benchmark"),
  ],
  targets: [
    .target(
      name: "IdentifiedCollectionsOld",
      dependencies: [
        .product(name: "OrderedCollectionsOld", package: "swift-collections-old")
      ]
    ),
    .testTarget(
      name: "IdentifiedCollectionsTests",
      dependencies: ["IdentifiedCollectionsOld"]
    ),
    .executableTarget(
      name: "swift-identified-collections-benchmark-old",
      dependencies: [
        "IdentifiedCollectionsOld",
        .product(name: "CollectionsBenchmarkOld", package: "swift-collections-benchmark-old"),
      ]
    ),
  ]
)

for target in package.targets {
  target.swiftSettings = target.swiftSettings ?? []
  target.swiftSettings!.append(contentsOf: [
    .enableExperimentalFeature("StrictConcurrency")
  ])
}

#if !os(Windows)
  // DocC needs to be ported to Windows
  // https://github.com/thebrowsercompany/swift-build/issues/39
  package.dependencies.append(
    .package(path: "../swift-docc-plugin-old")
  )
#endif
