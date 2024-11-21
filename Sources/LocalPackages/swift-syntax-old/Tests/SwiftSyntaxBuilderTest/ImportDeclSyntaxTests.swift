//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftSyntaxOld
import SwiftSyntaxBuilderOld
import XCTest

final class ImportDeclSyntaxTests: XCTestCase {
  func testImportDeclSyntax() {
    let identifier = TokenSyntax.identifier("SwiftSyntaxOld")

    let importDecl = ImportDeclSyntax(
      path: ImportPathComponentListSyntax([ImportPathComponentSyntax(name: identifier)])
    )

    assertBuildResult(importDecl, "import SwiftSyntaxOld")
  }

  func testImportWithAttribute() {
    let buildable = ImportDeclSyntax(
      attributes: [.attribute("@_exported")],
      path: [ImportPathComponentSyntax(name: "SwiftSyntaxOld")]
    )

    assertBuildResult(
      buildable,
      """
      @_exported import SwiftSyntaxOld
      """
    )
  }
}
