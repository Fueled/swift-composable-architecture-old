// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "swift-composable-architecture-old",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(
      name: "ComposableArchitectureOld",
      targets: ["ComposableArchitectureOld"]
    )
  ],
  dependencies: [
    .package(name: "BenchmarkOld", path: "./Sources/LocalPackages/swift-benchmark-old"),
    .package(path: "./Sources/LocalPackages/combine-schedulers-old"),
    .package(path: "./Sources/LocalPackages/swift-case-paths-old"),
    .package(path: "./Sources/LocalPackages/swift-custom-dump-old"),
    .package(path: "./Sources/LocalPackages/swift-identified-collections-old"),
    .package(path: "./Sources/LocalPackages/xctest-dynamic-overlay-old"),
  ],
  targets: [
    .target(
      name: "ComposableArchitectureOld",
      dependencies: [
        .product(name: "CasePathsOld", package: "swift-case-paths-old"),
        .product(name: "CombineSchedulersOld", package: "combine-schedulers-old"),
        .product(name: "CustomDumpOld", package: "swift-custom-dump-old"),
        .product(name: "IdentifiedCollectionsOld", package: "swift-identified-collections-old"),
        .product(name: "XCTestDynamicOverlayOld", package: "xctest-dynamic-overlay-old"),
      ]
    ),
    .testTarget(
      name: "ComposableArchitectureTests",
      dependencies: [
        "ComposableArchitectureOld"
      ]
    ),
    .executableTarget(
      name: "swift-composable-architecture-benchmark-old",
      dependencies: [
        "ComposableArchitectureOld",
        .product(name: "BenchmarkOld", package: "BenchmarkOld"),
      ]
    ),
  ]
)

#if swift(>=5.6)
  // Add the documentation compiler plugin if possible
  package.dependencies.append(
    .package(path: "./Sources/LocalPackages/swift-docc-plugin-old")
  )
#endif
