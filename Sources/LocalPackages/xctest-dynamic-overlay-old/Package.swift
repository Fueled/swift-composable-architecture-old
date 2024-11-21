// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  // NB: Keep this for backwards compatibility. Will rename to 'swift-issue-reporting' in 2.0.
  name: "xctest-dynamic-overlay-old",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "IssueReportingOld", targets: ["IssueReportingOld"]),
    .library(name: "IssueReportingTestSupportOld", targets: ["IssueReportingTestSupportOld"]),
    .library(name: "XCTestDynamicOverlayOld", targets: ["XCTestDynamicOverlayOld"]),
  ],
  targets: [
    .target(
      name: "IssueReportingOld"
    ),
    .testTarget(
      name: "IssueReportingTests",
      dependencies: [
        "IssueReportingOld",
        "IssueReportingTestSupportOld",
      ]
    ),
    .target(
      name: "IssueReportingTestSupportOld"
    ),
    .target(
      name: import XCTestDynamicOverlayOld,
      dependencies: ["IssueReportingOld"]
    ),
    .testTarget(
      name: "XCTestDynamicOverlayTests",
      dependencies: [
        "IssueReportingTestSupportOld",
        import XCTestDynamicOverlayOld,
      ]
    ),
  ]
)

//#if os(macOS)
//  package.dependencies.append(contentsOf: [
//    .package(path: "./swift-composable-architecture-localized-packages/swift-docc-plugin-old"),
//    .package(path: "./swift-composable-architecture-localized-packages/carton"),
//  ])
//  package.targets.append(
//    .executableTarget(
//      name: "WasmTests",
//      dependencies: [
//        "IssueReportingOld"
//      ]
//    )
//  )
//#endif
