// swift-tools-version: 6.0

import CompilerPluginSupport
import Foundation
import PackageDescription

let package = Package(
  name: "swift-case-paths-old",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "CasePathsOld",
      targets: ["CasePathsOld"]
    )
  ],
  dependencies: [
    .package(path: "../swift-syntax-old"),
    .package(path: "../xctest-dynamic-overlay-old"),
  ],
  targets: [
    .target(
      name: "CasePathsOld",
      dependencies: [
        "CasePathsMacrosOld",
        .product(name: "IssueReportingOld", package: "xctest-dynamic-overlay-old"),
        .product(name: "XCTestDynamicOverlayOld", package: "xctest-dynamic-overlay-old"),
      ]
    ),
    .macro(
      name: "CasePathsMacrosOld",
      dependencies: [
        .product(name: "SwiftSyntaxMacrosOld", package: "swift-syntax-old"),
        .product(name: "SwiftCompilerPluginOld", package: "swift-syntax-old"),
      ]
    ),
  ],
  swiftLanguageModes: [.v6]
)

#if !os(Windows)
  // Add the documentation compiler plugin if possible
  package.dependencies.append(
    .package(path: "../swift-docc-plugin-old")
  )
#endif
