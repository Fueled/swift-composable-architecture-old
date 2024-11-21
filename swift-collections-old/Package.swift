// swift-tools-version:5.7
//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Collections open source project
//
// Copyright (c) 2021 - 2024 Apple Inc. and the Swift project authors
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
//     swift build -Xswiftc -DCOLLECTIONS_INTERNAL_CHECKS
var defines: [String] = [

  // Enables internal consistency checks at the end of initializers and
  // mutating operations. This can have very significant overhead, so enabling
  // this setting invalidates all documented performance guarantees.
  //
  // This is mostly useful while debugging an issue with the implementation of
  // the hash table itself. This setting should never be enabled in production
  // code.
//  "COLLECTIONS_INTERNAL_CHECKS",

  // Hashing collections provided by this package usually seed their hash
  // function with the address of the memory location of their storage,
  // to prevent some common hash table merge/copy operations from regressing to
  // quadratic behavior. This setting turns off this mechanism, seeding
  // the hash function with the table's size instead.
  //
  // When used in conjunction with the SWIFT_DETERMINISTIC_HASHING environment
  // variable, this enables reproducible hashing behavior.
  //
  // This is mostly useful while debugging an issue with the implementation of
  // the hash table itself. This setting should never be enabled in production
  // code.
//  "COLLECTIONS_DETERMINISTIC_HASHING",

  // Enables randomized testing of some data structure implementations.
  "COLLECTIONS_RANDOMIZED_TESTING",

  // Enable this to build the sources as a single, large module.
  // This removes the distinct modules for each data structure, instead
  // putting them all directly into the `Collections` module.
  // Note: This is a source-incompatible variation of the default configuration.
//  "COLLECTIONS_SINGLE_MODULE",
]

var _settings: [SwiftSetting] = defines.map { .define($0) }

struct CustomTarget {
  enum Kind {
    case exported
    case hidden
    case test
    case testSupport
  }

  var kind: Kind
  var name: String
  var dependencies: [Target.Dependency]
  var directory: String
  var exclude: [String]
}

extension CustomTarget.Kind {
  func path(for name: String) -> String {
    switch self {
    case .exported, .hidden: return "Sources/\(name)"
    case .test, .testSupport: return "Tests/\(name)"
    }
  }

  var isTest: Bool {
    switch self {
    case .exported, .hidden: return false
    case .test, .testSupport: return true
    }
  }
}

extension CustomTarget {
  static func target(
    kind: Kind,
    name: String,
    dependencies: [Target.Dependency] = [],
    directory: String? = nil,
    exclude: [String] = []
  ) -> CustomTarget {
    CustomTarget(
      kind: kind,
      name: name,
      dependencies: dependencies,
      directory: directory ?? name,
      exclude: exclude)
  }

  func toTarget() -> Target {
    var linkerSettings: [LinkerSetting] = []
    if kind == .testSupport {
      linkerSettings.append(
        .linkedFramework("XCTest", .when(platforms: [.macOS, .iOS, .watchOS, .tvOS])))
    }
    switch kind {
    case .exported, .hidden, .testSupport:
      return Target.target(
        name: name,
        dependencies: dependencies,
        path: kind.path(for: directory),
        exclude: exclude,
        swiftSettings: _settings,
        linkerSettings: linkerSettings)
    case .test:
      return Target.testTarget(
        name: name,
        dependencies: dependencies,
        path: kind.path(for: directory),
        exclude: exclude,
        swiftSettings: _settings,
        linkerSettings: linkerSettings)
    }
  }
}

extension Array where Element == CustomTarget {
  func toMonolithicTarget(
    name: String,
    linkerSettings: [LinkerSetting] = []
  ) -> Target {
    let targets = self.filter { !$0.kind.isTest }
    return Target.target(
      name: name,
      path: "Sources",
      exclude: [
        "CMakeLists.txt",
        "BitCollectionsOld/BitCollectionsOld.docc",
        "Collections/Collections.docc",
        "DequeModuleOld/DequeModuleOld.docc",
        "HashTreeCollectionsOld/HashTreeCollectionsOld.docc",
        "HeapModuleOld/HeapModuleOld.docc",
        "OrderedCollections/OrderedCollections.docc",
      ] + targets.flatMap { t in
        t.exclude.map { "\(t.name)/\($0)" }
      },
      sources: targets.map { "\($0.directory)" },
      swiftSettings: _settings,
      linkerSettings: linkerSettings)
  }

  func toMonolithicTestTarget(
    name: String,
    dependencies: [Target.Dependency] = [],
    linkerSettings: [LinkerSetting] = []
  ) -> Target {
    let targets = self.filter { $0.kind.isTest }
    return Target.testTarget(
      name: name,
      dependencies: dependencies,
      path: "Tests",
      exclude: [
        "README.md",
      ] + targets.flatMap { t in
        t.exclude.map { "\(t.name)/\($0)" }
      },
      sources: targets.map { "\($0.name)" },
      swiftSettings: _settings,
      linkerSettings: linkerSettings)
  }
}

let targets: [CustomTarget] = [
  .target(
    kind: .testSupport,
    name: "_CollectionsTestSupport",
    dependencies: ["InternalCollectionsUtilitiesOld"]),
  .target(
    kind: .test,
    name: "CollectionsTestSupportTests",
    dependencies: ["_CollectionsTestSupport"]),
  .target(
    kind: .hidden,
    name: "InternalCollectionsUtilitiesOld",
    exclude: [
      "CMakeLists.txt",
      "Compatibility/UnsafeMutableBufferPointer+SE-0370.swift.gyb",
      "Compatibility/UnsafeMutablePointer+SE-0370.swift.gyb",
      "Compatibility/UnsafeRawPointer extensions.swift.gyb",
      "Debugging.swift.gyb",
      "Descriptions.swift.gyb",
      "IntegerTricks/FixedWidthInteger+roundUpToPowerOfTwo.swift.gyb",
      "IntegerTricks/Integer rank.swift.gyb",
      "IntegerTricks/UInt+first and last set bit.swift.gyb",
      "IntegerTricks/UInt+reversed.swift.gyb",
      "RandomAccessCollection+Offsets.swift.gyb",
      "Specialize.swift.gyb",
      "UnsafeBitSet/_UnsafeBitSet+Index.swift.gyb",
      "UnsafeBitSet/_UnsafeBitSet+_Word.swift.gyb",
      "UnsafeBitSet/_UnsafeBitSet.swift.gyb",
      "UnsafeBufferPointer+Extras.swift.gyb",
      "UnsafeMutableBufferPointer+Extras.swift.gyb",
    ]),

  .target(
    kind: .exported,
    name: "BitCollectionsOld",
    dependencies: ["InternalCollectionsUtilitiesOld"],
    exclude: ["CMakeLists.txt"]),
  .target(
    kind: .test,
    name: "BitCollectionsTests",
    dependencies: [
      "BitCollectionsOld", "_CollectionsTestSupport", "OrderedCollectionsOld"
    ]),

  .target(
    kind: .exported,
    name: "DequeModuleOld",
    dependencies: ["InternalCollectionsUtilitiesOld"],
    exclude: ["CMakeLists.txt"]),
  .target(
    kind: .test,
    name: "DequeTests",
    dependencies: ["DequeModuleOld", "_CollectionsTestSupport"]),

  .target(
    kind: .exported,
    name: "HashTreeCollectionsOld",
    dependencies: ["InternalCollectionsUtilitiesOld"],
    exclude: ["CMakeLists.txt"]),
  .target(
    kind: .test,
    name: "HashTreeCollectionsTests",
    dependencies: ["HashTreeCollectionsOld", "_CollectionsTestSupport"]),

  .target(
    kind: .exported,
    name: "HeapModuleOld",
    dependencies: ["InternalCollectionsUtilitiesOld"],
    exclude: ["CMakeLists.txt"]),
  .target(
    kind: .test,
    name: "HeapTests",
    dependencies: ["HeapModuleOld", "_CollectionsTestSupport"]),

  .target(
    kind: .exported,
    name: "OrderedCollectionsOld",
    dependencies: ["InternalCollectionsUtilitiesOld"],
    exclude: ["CMakeLists.txt"]),
  .target(
    kind: .test,
    name: "OrderedCollectionsTests",
    dependencies: ["OrderedCollectionsOld", "_CollectionsTestSupport"]),

  .target(
    kind: .exported,
    name: "_RopeModuleOld",
    dependencies: ["InternalCollectionsUtilitiesOld"],
    directory: "RopeModule",
    exclude: ["CMakeLists.txt"]),
  .target(
    kind: .test,
    name: "RopeModuleTests",
    dependencies: ["_RopeModuleOld", "_CollectionsTestSupport"]),

  .target(
    kind: .exported,
    name: "SortedCollectionsOld",
    dependencies: ["InternalCollectionsUtilitiesOld"],
    directory: "SortedCollectionsOld"),
  .target(
    kind: .test,
    name: "SortedCollectionsTests",
    dependencies: ["SortedCollectionsOld", "_CollectionsTestSupport"]),

  .target(
    kind: .exported,
    name: "CollectionsOld",
    dependencies: [
      "BitCollectionsOld",
      "DequeModuleOld",
      "HashTreeCollectionsOld",
      "HeapModuleOld",
      "OrderedCollectionsOld",
      "_RopeModuleOld",
      "SortedCollectionsOld",
    ],
    exclude: ["CMakeLists.txt"])
]

var _products: [Product] = []
var _targets: [Target] = []
if defines.contains("COLLECTIONS_SINGLE_MODULE") {
  _products = [
    .library(name: "CollectionsOld", targets: ["CollectionsOld"]),
  ]
  _targets = [
    targets.toMonolithicTarget(name: "CollectionsOld"),
    targets.toMonolithicTestTarget(
      name: "CollectionsTests",
    dependencies: ["CollectionsOld"]),
  ]
} else {
  _products = targets.compactMap { t in
    guard t.kind == .exported else { return nil }
    return .library(name: t.name, targets: [t.name])
  }
  _targets = targets.map { $0.toTarget() }
}

let package = Package(
  name: "swift-collections-old",
  products: _products,
  targets: _targets
)
