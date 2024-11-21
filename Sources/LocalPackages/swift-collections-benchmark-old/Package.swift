// swift-tools-version:5.3
//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Collections open source project
//
// Copyright (c) 2021 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import PackageDescription


// This package recognizes the conditional compilation flags listed below.
// To use enable them, uncomment the corresponding lines or define them
// from the package manager command line:
//
//     swift build -Xswiftc -DUSE_FOUNDATION_DATE
var settings: [SwiftSetting]? = [

  // On Apple platforms, measure time using Foundation's `Date` instead of
  // the default method. This is useful when you want to run benchmarks
  // on an operating system that predates the introduction of the function
  // this package would otherwise be using.
//  .define("USE_FOUNDATION_DATE"),
]

// Prevent SPM 5.3 from throwing an error on empty settings arrays.
// (This has been fixed in 5.4.)
if settings?.isEmpty == true { settings = nil }

let package = Package(
  name: "swift-collections-benchmark-old",
  products: [
    .library(name: "CollectionsBenchmarkOld", targets: ["CollectionsBenchmarkOld"]),
  ],
  dependencies: [
    .package(path: "../swift-argument-parser-old"),
    .package(path: "../swift-system-old"),
  ],
  targets: [
    .target(
      name: "CollectionsBenchmarkOld",
      dependencies: [
        .product(name: "ArgumentParserOld", package: "swift-argument-parser-old"),
        .product(name: "SystemPackageOld", package: "swift-system-old"),
      ],
      path: "Sources/CollectionsBenchmarkOld",
      swiftSettings: settings),
    .testTarget(
      name: "CollectionsBenchmarkTests",
      dependencies: ["CollectionsBenchmarkOld"],
      swiftSettings: settings),
  ]
)
