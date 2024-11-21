// swift-tools-version:5.8
//===----------------------------------------------------------*- swift -*-===//
//
// This source file is part of the Swift Argument Parser open source project
//
// Copyright (c) 2020 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import PackageDescription

var package = Package(
    name: "swift-argument-parser-old",
    products: [
        .library(
            name: "ArgumentParserOld",
            targets: ["ArgumentParserOld"]),
        .plugin(
            name: "GenerateManualOld",
            targets: ["GenerateManualOld"]),
    ],
    dependencies: [],
    targets: [
        // Core Library
        .target(
            name: "ArgumentParserOld",
            dependencies: ["ArgumentParserToolInfo"],
            exclude: ["CMakeLists.txt"],
            swiftSettings: [
              .enableExperimentalFeature("StrictConcurrency"),
            ]),
        .target(
            name: "ArgumentParserTestHelpers",
            dependencies: ["ArgumentParserOld", "ArgumentParserToolInfo"],
            exclude: ["CMakeLists.txt"]),
        .target(
            name: "ArgumentParserToolInfo",
            dependencies: [ ],
            exclude: ["CMakeLists.txt"]),

        // Plugins
        .plugin(
            name: "GenerateManualOld",
            capability: .command(
                intent: .custom(
                    verb: "generate-manual",
                    description: "Generate a manual entry for a specified target.")),
            dependencies: ["generate-manual"]),

        // Examples
        .executableTarget(
            name: "roll",
            dependencies: ["ArgumentParserOld"],
            path: "Examples/roll"),
        .executableTarget(
            name: "math",
            dependencies: ["ArgumentParserOld"],
            path: "Examples/math"),
        .executableTarget(
            name: "repeat",
            dependencies: ["ArgumentParserOld"],
            path: "Examples/repeat"),
        .executableTarget(
            name: "color",
            dependencies: ["ArgumentParserOld"],
            path: "Examples/color"),

        // Tools
        .executableTarget(
            name: "generate-manual",
            dependencies: ["ArgumentParserOld", "ArgumentParserToolInfo"],
            path: "Tools/generate-manual"),
    
        // Tests
        .testTarget(
            name: "ArgumentParserEndToEndTests",
            dependencies: ["ArgumentParserOld", "ArgumentParserTestHelpers"],
            exclude: ["CMakeLists.txt"]),
        .testTarget(
            name: "ArgumentParserExampleTests",
            dependencies: ["ArgumentParserTestHelpers"],
            resources: [.copy("CountLinesTest.txt")]),
        .testTarget(
            name: "ArgumentParserGenerateManualTests",
            dependencies: ["ArgumentParserTestHelpers"]),
        .testTarget(
            name: "ArgumentParserPackageManagerTests",
            dependencies: ["ArgumentParserOld", "ArgumentParserTestHelpers"],
            exclude: ["CMakeLists.txt"]),
        .testTarget(
            name: "ArgumentParserUnitTests",
            dependencies: ["ArgumentParserOld", "ArgumentParserTestHelpers"],
            exclude: ["CMakeLists.txt"]),
    ]
)

#if os(macOS)
package.targets.append(contentsOf: [
    // Examples
    .executableTarget(
        name: "count-lines",
        dependencies: ["ArgumentParserOld"],
        path: "Examples/count-lines"),

    // Tools
    .executableTarget(
        name: "changelog-authors",
        dependencies: ["ArgumentParserOld"],
        path: "Tools/changelog-authors"),
    ])
#endif
