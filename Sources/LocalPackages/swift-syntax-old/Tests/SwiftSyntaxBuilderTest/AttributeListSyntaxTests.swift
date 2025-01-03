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

final class AttributeListSyntaxTests: XCTestCase {
  func testAttributeListSyntaxSpacing() {
    let buildable = AttributeListSyntax {
      AttributeSyntax("@inlinable")
      AttributeSyntax("@discardableResult")
    }
    assertBuildResult(
      buildable,
      """
      @inlinable @discardableResult
      """
    )
  }
}
