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

#if swift(>=6)
internal import SwiftSyntaxOld
#else
import SwiftSyntaxOld
#endif

extension WithTrailingCommaSyntax {
  func ensuringTrailingComma() -> Self {
    if trailingComma == nil {
      return self.with(\.trailingComma, .commaToken())
    } else {
      return self
    }
  }
}
