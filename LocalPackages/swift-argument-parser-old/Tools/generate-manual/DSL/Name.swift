//===----------------------------------------------------------*- swift -*-===//
//
// This source file is part of the Swift Argument Parser open source project
//
// Copyright (c) 2021 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import ArgumentParserOld
import ArgumentParserToolInfo

struct Name: MDocComponent {
  var command: CommandInfoV0

  var body: MDocComponent {
    Section(title: "name") {
      MDocMacro.DocumentName(name: command.manualPageName)
      if let abstract = command.abstract {
        MDocMacro.DocumentDescription(description: abstract)
      }
    }
  }
}
