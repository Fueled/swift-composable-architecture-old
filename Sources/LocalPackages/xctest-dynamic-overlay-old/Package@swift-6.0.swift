// swift-tools-version: 6.0

import PackageDescription

let package = Package(
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
      name: "XCTestDynamicOverlayOld",
      dependencies: ["IssueReportingOld"]
    ),
    .testTarget(
      name: "XCTestDynamicOverlayTests",
      dependencies: [
        "IssueReportingTestSupportOld",
        "XCTestDynamicOverlayOld",
      ]
    ),
  ],
  swiftLanguageModes: [.v6]
)

//#if os(Linux) || os(Windows)
//  package.dependencies.append(
//    .package(path: "./swift-composable-architecture-localized-packages/swift-testing")
//  )
//#endif

//#if os(macOS)
//  package.dependencies.append(contentsOf: [
//    .package(path: "./swift-composable-architecture-localized-packages/swift-docc-plugin-old"),
//    .package(path: "./swift-composable-architecture-localized-packages/carton-old"),
//  ])
//  package.targets.append(
//    .executableTarget(
//      name: "WasmTestsOld",
//      dependencies: [
//        "IssueReportingOld"
//      ]
//    )
//  )
//#endif
