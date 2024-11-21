// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "swift-macro-testing-old",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "MacroTestingOld",
      targets: ["MacroTestingOld"]
    )
  ],
  dependencies: [
    .package(path: "../swift-snapshot-testing-old"),
    .package(path: "../swift-syntax-old"),
  ],
  targets: [
    .target(
      name: "MacroTestingOld",
      dependencies: [
        .product(name: "InlineSnapshotTestingOld", package: "swift-snapshot-testing-old"),
        .product(name: "SwiftDiagnosticsOld", package: "swift-syntax-old"),
        .product(name: "SwiftOperatorsOld", package: "swift-syntax-old"),
        .product(name: "SwiftParserDiagnosticsOld", package: "swift-syntax-old"),
        .product(name: "SwiftSyntaxMacrosOld", package: "swift-syntax-old"),
        .product(name: "SwiftSyntaxMacrosTestSupportOld", package: "swift-syntax-old"),
      ]
    ),
    .testTarget(
      name: "MacroTestingTests",
      dependencies: [
        "MacroTestingOld"
      ]
    ),
  ]
)
