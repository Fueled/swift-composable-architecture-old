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

import SwiftParserOld
import SwiftSyntaxOld
import XCTest
import _SwiftSyntaxTestSupportOld

class VisitorPerformanceTests: XCTestCase {

  var inputFile: URL {
    return URL(fileURLWithPath: #filePath)
      .deletingLastPathComponent()
      .appendingPathComponent("Inputs")
      .appendingPathComponent("MinimalCollections.swift.input")
  }

  func testEmptyVisitorPerformance() throws {
    try XCTSkipIf(longTestsDisabled)
    class EmptyVisitor: SyntaxVisitor {}

    let source = try String(contentsOf: inputFile, encoding: .utf8)
    let parsed = Parser.parse(source: source)
    let emptyVisitor = EmptyVisitor(viewMode: .sourceAccurate)

    try measureInstructions {
      emptyVisitor.walk(parsed)
    }
  }

  func testEmptyRewriterPerformance() throws {
    try XCTSkipIf(longTestsDisabled)
    class EmptyRewriter: SyntaxRewriter {}

    let source = try String(contentsOf: inputFile, encoding: .utf8)
    let parsed = Parser.parse(source: source)
    let emptyRewriter = EmptyRewriter(viewMode: .sourceAccurate)

    try measureInstructions {
      _ = emptyRewriter.rewrite(parsed)
    }
  }

  func testEmptyAnyVisitorPerformance() throws {
    try XCTSkipIf(longTestsDisabled)
    class EmptyAnyVisitor: SyntaxAnyVisitor {}

    let source = try String(contentsOf: inputFile, encoding: .utf8)
    let parsed = Parser.parse(source: source)
    let emptyVisitor = EmptyAnyVisitor(viewMode: .sourceAccurate)

    try measureInstructions {
      emptyVisitor.walk(parsed)
    }
  }
}
