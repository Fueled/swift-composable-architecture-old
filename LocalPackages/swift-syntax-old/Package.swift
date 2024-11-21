// swift-tools-version:5.8

import Foundation
import PackageDescription

let products: [Product]

if buildDynamicLibrary {
  products = [
    .library(
      name: "_SwiftSyntaxDynamicOld",
      type: .dynamic,
      targets: [
        "SwiftBasicFormatOld",
        "SwiftDiagnosticsOld",
        "SwiftIDEUtilsOld",
        "SwiftParserOld",
        "SwiftParserDiagnosticsOld",
        "SwiftRefactorOld",
        "SwiftSyntaxOld",
        "SwiftSyntaxBuilderOld",
      ]
    )
  ]
} else {
  products = [
    .library(name: "SwiftBasicFormatOld", targets: ["SwiftBasicFormatOld"]),
    .library(name: "SwiftCompilerPluginOld", targets: ["SwiftCompilerPluginOld"]),
    .library(name: "SwiftDiagnosticsOld", targets: ["SwiftDiagnosticsOld"]),
    .library(name: "SwiftIDEUtilsOld", targets: ["SwiftIDEUtilsOld"]),
    .library(name: "SwiftIfConfigOld", targets: ["SwiftIfConfigOld"]),
    .library(name: "SwiftLexicalLookupOld", targets: ["SwiftLexicalLookupOld"]),
    .library(name: "SwiftOperatorsOld", targets: ["SwiftOperatorsOld"]),
    .library(name: "SwiftParserOld", targets: ["SwiftParserOld"]),
    .library(name: "SwiftParserDiagnosticsOld", targets: ["SwiftParserDiagnosticsOld"]),
    .library(name: "SwiftRefactorOld", targets: ["SwiftRefactorOld"]),
    .library(name: "SwiftSyntaxOld", targets: ["SwiftSyntaxOld"]),
    .library(name: "SwiftSyntaxBuilderOld", targets: ["SwiftSyntaxBuilderOld"]),
    .library(name: "SwiftSyntaxMacrosOld", targets: ["SwiftSyntaxMacrosOld"]),
    .library(name: "SwiftSyntaxMacroExpansionOld", targets: ["SwiftSyntaxMacroExpansionOld"]),
    .library(name: "SwiftSyntaxMacrosTestSupportOld", targets: ["SwiftSyntaxMacrosTestSupportOld"]),
    .library(name: "SwiftSyntaxMacrosGenericTestSupportOld", targets: ["SwiftSyntaxMacrosGenericTestSupportOld"]),
    .library(name: "_SwiftCompilerPluginMessageHandlingOld", targets: ["SwiftCompilerPluginMessageHandlingOld"]),
    .library(name: "_SwiftLibraryPluginProviderOld", targets: ["SwiftLibraryPluginProviderOld"]),
  ]
}

let package = Package(
  name: "swift-syntax-old",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6),
    .macCatalyst(.v13),
  ],
  products: products,
  targets: [
    // MARK: - Internal helper targets
    .target(
      name: "_SwiftSyntaxCShimsOld"
    ),

    .target(
      name: "_InstructionCounterOld"
    ),

    .target(
      name: "_SwiftSyntaxTestSupportOld",
      dependencies: [
        "_SwiftSyntaxGenericTestSupportOld",
        "SwiftBasicFormatOld",
        "SwiftSyntaxOld",
        "SwiftSyntaxBuilderOld",
        "SwiftSyntaxMacroExpansionOld",
      ]
    ),

    .target(
      name: "_SwiftSyntaxGenericTestSupportOld",
      dependencies: []
    ),

    .testTarget(
      name: "SwiftSyntaxTestSupportTest",
      dependencies: ["_SwiftSyntaxTestSupportOld", "SwiftParserOld"]
    ),

    // MARK: - Library targets
    // Formatting style:
    //  - One section for each target and its test target
    //  - Sections are sorted alphabetically
    //  - Each target argument takes exactly one line, unless there are external dependencies.
    //    In that case package and internal dependencies are on different lines.
    //  - All array elements are sorted alphabetically

    // MARK: SwiftBasicFormatOld

    .target(
      name: "SwiftBasicFormatOld",
      dependencies: ["SwiftSyntaxOld"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftBasicFormatTest",
      dependencies: ["_SwiftSyntaxTestSupportOld", "SwiftBasicFormatOld", "SwiftSyntaxBuilderOld"]
    ),

    // MARK: SwiftCompilerPluginOld

    .target(
      name: "SwiftCompilerPluginOld",
      dependencies: ["SwiftCompilerPluginMessageHandlingOld", "SwiftSyntaxMacrosOld"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftCompilerPluginTest",
      dependencies: ["SwiftCompilerPluginOld"]
    ),

    // MARK: SwiftCompilerPluginMessageHandlingOld

    .target(
      name: "SwiftCompilerPluginMessageHandlingOld",
      dependencies: [
        "_SwiftSyntaxCShimsOld",
        "SwiftDiagnosticsOld",
        "SwiftOperatorsOld",
        "SwiftParserOld",
        "SwiftSyntaxOld",
        "SwiftSyntaxMacrosOld",
        "SwiftSyntaxMacroExpansionOld",
      ],
      exclude: ["CMakeLists.txt"]
    ),

    // MARK: SwiftDiagnosticsOld

    .target(
      name: "SwiftDiagnosticsOld",
      dependencies: ["SwiftSyntaxOld"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftDiagnosticsTest",
      dependencies: ["_SwiftSyntaxTestSupportOld", "SwiftDiagnosticsOld", "SwiftParserOld", "SwiftParserDiagnosticsOld"]
    ),

    // MARK: SwiftIDEUtilsOld

    .target(
      name: "SwiftIDEUtilsOld",
      dependencies: ["SwiftSyntaxOld", "SwiftDiagnosticsOld", "SwiftParserOld"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftIDEUtilsTest",
      dependencies: ["_SwiftSyntaxTestSupportOld", "SwiftIDEUtilsOld", "SwiftParserOld", "SwiftSyntaxOld"]
    ),

    // MARK: SwiftIfConfig

    .target(
      name: "SwiftIfConfigOld",
      dependencies: ["SwiftSyntaxOld", "SwiftSyntaxBuilderOld", "SwiftDiagnosticsOld", "SwiftOperatorsOld"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftIfConfigTest",
      dependencies: [
        "_SwiftSyntaxTestSupportOld",
        "SwiftIfConfigOld",
        "SwiftParserOld",
        "SwiftSyntaxMacrosGenericTestSupportOld",
      ]
    ),

    // MARK: SwiftLexicalLookup

    .target(
      name: "SwiftLexicalLookupOld",
      dependencies: ["SwiftSyntaxOld", "SwiftIfConfigOld"]
    ),

    .testTarget(
      name: "SwiftLexicalLookupTest",
      dependencies: ["_SwiftSyntaxTestSupportOld", "SwiftLexicalLookupOld"]
    ),

    // MARK: SwiftLibraryPluginProviderOld

    .target(
      name: "SwiftLibraryPluginProviderOld",
      dependencies: ["SwiftSyntaxMacrosOld", "SwiftCompilerPluginMessageHandlingOld", "_SwiftLibraryPluginProviderCShimsOld"],
      exclude: ["CMakeLists.txt"]
    ),

    .target(
      name: "_SwiftLibraryPluginProviderCShimsOld",
      exclude: ["CMakeLists.txt"]
    ),

    // MARK: SwiftSyntaxOld

    .target(
      name: "SwiftSyntaxOld",
      dependencies: ["_SwiftSyntaxCShimsOld", "SwiftSyntax509Old", "SwiftSyntax510Old", "SwiftSyntax600Old"],
      exclude: ["CMakeLists.txt"],
      swiftSettings: swiftSyntaxSwiftSettings
    ),

    .testTarget(
      name: "SwiftSyntaxTest",
      dependencies: ["_SwiftSyntaxTestSupportOld", "SwiftSyntaxOld", "SwiftSyntaxBuilderOld"],
      swiftSettings: swiftSyntaxSwiftSettings
    ),

    // MARK: Version marker modules

    .target(
      name: "SwiftSyntax509Old",
      path: "Sources/VersionMarkerModules/SwiftSyntax509Old"
    ),

    .target(
      name: "SwiftSyntax510Old",
      path: "Sources/VersionMarkerModules/SwiftSyntax510Old"
    ),

    .target(
      name: "SwiftSyntax600Old",
      path: "Sources/VersionMarkerModules/SwiftSyntax600Old"
    ),

    .target(
      name: "SwiftSyntax601Old",
      path: "Sources/VersionMarkerModules/SwiftSyntax601Old"
    ),

    // MARK: SwiftSyntaxBuilderOld

    .target(
      name: "SwiftSyntaxBuilderOld",
      dependencies: ["SwiftBasicFormatOld", "SwiftParserOld", "SwiftDiagnosticsOld", "SwiftParserDiagnosticsOld", "SwiftSyntaxOld"],
      exclude: ["CMakeLists.txt"],
      swiftSettings: swiftSyntaxBuilderSwiftSettings
    ),

    .testTarget(
      name: "SwiftSyntaxBuilderTest",
      dependencies: ["_SwiftSyntaxTestSupportOld", "SwiftSyntaxBuilderOld"],
      swiftSettings: swiftSyntaxBuilderSwiftSettings
    ),

    // MARK: SwiftSyntaxMacrosOld

    .target(
      name: "SwiftSyntaxMacrosOld",
      dependencies: ["SwiftDiagnosticsOld", "SwiftParserOld", "SwiftSyntaxOld", "SwiftSyntaxBuilderOld"],
      exclude: ["CMakeLists.txt"]
    ),

    // MARK: SwiftSyntaxMacroExpansionOld

    .target(
      name: "SwiftSyntaxMacroExpansionOld",
      dependencies: ["SwiftSyntaxOld", "SwiftSyntaxBuilderOld", "SwiftSyntaxMacrosOld", "SwiftDiagnosticsOld", "SwiftOperatorsOld"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftSyntaxMacroExpansionTest",
      dependencies: [
        "SwiftSyntaxOld",
        "_SwiftSyntaxTestSupportOld",
        "SwiftDiagnosticsOld",
        "SwiftOperatorsOld",
        "SwiftParserOld",
        "SwiftSyntaxBuilderOld",
        "SwiftSyntaxMacrosOld",
        "SwiftSyntaxMacroExpansionOld",
        "SwiftSyntaxMacrosTestSupportOld",
      ]
    ),

    // MARK: SwiftSyntaxMacrosTestSupportOld

    .target(
      name: "SwiftSyntaxMacrosTestSupportOld",
      dependencies: [
        "SwiftSyntaxOld",
        "SwiftSyntaxMacroExpansionOld",
        "SwiftSyntaxMacrosOld",
        "SwiftSyntaxMacrosGenericTestSupportOld",
      ]
    ),

    // MARK: SwiftSyntaxMacrosGenericTestSupportOld

    .target(
      name: "SwiftSyntaxMacrosGenericTestSupportOld",
      dependencies: [
        "_SwiftSyntaxGenericTestSupportOld",
        "SwiftDiagnosticsOld",
        "SwiftIDEUtilsOld",
        "SwiftParserOld",
        "SwiftSyntaxMacrosOld",
        "SwiftSyntaxMacroExpansionOld",
      ]
    ),

    .testTarget(
      name: "SwiftSyntaxMacrosTestSupportTests",
      dependencies: ["SwiftDiagnosticsOld", "SwiftSyntaxOld", "SwiftSyntaxMacrosOld", "SwiftSyntaxMacrosTestSupportOld"]
    ),

    // MARK: SwiftParserOld

    .target(
      name: "SwiftParserOld",
      dependencies: ["SwiftSyntaxOld"],
      exclude: ["CMakeLists.txt", "README.md"],
      swiftSettings: swiftParserSwiftSettings
    ),

    .testTarget(
      name: "SwiftParserTest",
      dependencies: [
        "_SwiftSyntaxTestSupportOld",
        "SwiftDiagnosticsOld",
        "SwiftIDEUtilsOld",
        "SwiftOperatorsOld",
        "SwiftParserOld",
        "SwiftSyntaxBuilderOld",
      ],
      swiftSettings: swiftParserSwiftSettings
    ),

    // MARK: SwiftParserDiagnosticsOld

    .target(
      name: "SwiftParserDiagnosticsOld",
      dependencies: ["SwiftBasicFormatOld", "SwiftDiagnosticsOld", "SwiftParserOld", "SwiftSyntaxOld"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftParserDiagnosticsTest",
      dependencies: ["SwiftDiagnosticsOld", "SwiftParserDiagnosticsOld"]
    ),

    // MARK: SwiftOperatorsOld

    .target(
      name: "SwiftOperatorsOld",
      dependencies: ["SwiftDiagnosticsOld", "SwiftParserOld", "SwiftSyntaxOld"],
      exclude: [
        "CMakeLists.txt"
      ]
    ),

    .testTarget(
      name: "SwiftOperatorsTest",
      dependencies: ["_SwiftSyntaxTestSupportOld", "SwiftOperatorsOld", "SwiftParserOld"]
    ),

    // MARK: SwiftRefactorOld

    .target(
      name: "SwiftRefactorOld",
      dependencies: ["SwiftBasicFormatOld", "SwiftParserOld", "SwiftSyntaxOld", "SwiftSyntaxBuilderOld"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftRefactorTest",
      dependencies: ["_SwiftSyntaxTestSupportOld", "SwiftRefactorOld"]
    ),

    // MARK: - Deprecated targets

    // MARK: PerformanceTest
    // TODO: Should be included in SwiftParserTest/SwiftSyntaxTest

    .testTarget(
      name: "PerformanceTest",
      dependencies: ["_InstructionCounterOld", "_SwiftSyntaxTestSupportOld", "SwiftIDEUtilsOld", "SwiftParserOld", "SwiftSyntaxOld"],
      exclude: ["Inputs"]
    ),
  ],
  swiftLanguageVersions: [.v5, .version("6")]
)

// This is a fake target that depends on all targets in the package.
// We need to define it manually because the `SwiftSyntaxOld-Package` target doesn't exist for `swift build`.

package.targets.append(
  .target(
    name: "SwiftSyntax-all-old",
    dependencies: package.targets.compactMap {
      if $0.type == .test {
        return nil
      } else {
        return .byName(name: $0.name)
      }
    }
  )
)

// MARK: - Parse build arguments

func hasEnvironmentVariable(_ name: String) -> Bool {
  return ProcessInfo.processInfo.environment[name] != nil
}

/// Set when building swift-syntax using swift-syntax-dev-utils or in Swift CI in general.
///
/// Modifies the build in the following ways
///  - Enables assertions even in release builds
///  - Removes the dependency of swift-syntax on os_log
var buildScriptEnvironment: Bool { hasEnvironmentVariable("SWIFT_BUILD_SCRIPT_ENVIRONMENT") }

/// Check that the layout of the syntax tree is correct.
///
/// See CONTRIBUTING.md for more information
var rawSyntaxValidation: Bool { hasEnvironmentVariable("SWIFTSYNTAX_ENABLE_RAWSYNTAX_VALIDATION") }

/// Mutate the input of `assertParse` test cases.
///
/// See CONTRIBUTING.md for more information
var alternateTokenIntrospection: Bool { hasEnvironmentVariable("SWIFTPARSER_ENABLE_ALTERNATE_TOKEN_INTROSPECTION") }

/// Instead of building object files for all modules to be statically linked, build a single dynamic library.
///
/// This allows us to build swift-syntax as dynamic libraries, which in turn allows us to build SourceKit-LSP using
/// SwiftPM on Windows. Linking swift-syntax statically into sourcekit-lsp exceeds the maximum number of exported
/// symbols on Windows.
var buildDynamicLibrary: Bool { hasEnvironmentVariable("SWIFTSYNTAX_BUILD_DYNAMIC_LIBRARY") }

// MARK: - Compute custom build settings

// These build settings apply to the target and the corresponding test target.
var swiftSyntaxSwiftSettings: [SwiftSetting] {
  var settings: [SwiftSetting] = []
  if buildScriptEnvironment {
    settings.append(.define("SWIFTSYNTAX_ENABLE_ASSERTIONS"))
  }
  if rawSyntaxValidation {
    settings.append(.define("SWIFTSYNTAX_ENABLE_RAWSYNTAX_VALIDATION"))
  }
  return settings
}
var swiftSyntaxBuilderSwiftSettings: [SwiftSetting] {
  if buildScriptEnvironment {
    return [.define("SWIFTSYNTAX_NO_OSLOG_DEPENDENCY")]
  } else {
    return []
  }
}
var swiftParserSwiftSettings: [SwiftSetting] {
  if alternateTokenIntrospection {
    return [.define("SWIFTPARSER_ENABLE_ALTERNATE_TOKEN_INTROSPECTION")]
  } else {
    return []
  }
}
