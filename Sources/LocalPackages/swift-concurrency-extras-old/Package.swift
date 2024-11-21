// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "swift-concurrency-extras-old",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "ConcurrencyExtrasOld",
      targets: ["ConcurrencyExtrasOld"]
    )
  ],
  targets: [
    .target(
      name: "ConcurrencyExtrasOld"
    ),
    .testTarget(
      name: "ConcurrencyExtrasTests",
      dependencies: [
        "ConcurrencyExtrasOld"
      ]
    ),
  ]
)

#if !os(Windows)
  // Add the documentation compiler plugin if possible
  package.dependencies.append(
    .package(path: "../swift-docc-plugin-old")
  )
#endif

for target in package.targets {
  target.swiftSettings = target.swiftSettings ?? []
  target.swiftSettings!.append(contentsOf: [
    .enableExperimentalFeature("StrictConcurrency")
  ])
}
