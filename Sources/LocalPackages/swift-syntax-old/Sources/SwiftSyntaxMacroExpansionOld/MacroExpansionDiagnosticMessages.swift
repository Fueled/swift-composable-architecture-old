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
public import SwiftSyntaxMacrosOld
#else
import SwiftSyntaxMacrosOld
#endif

@available(*, deprecated, message: "MacroExpansionErrorMessage has been moved to the SwiftSyntaxMacrosOld module")
public typealias MacroExpansionErrorMessage = SwiftSyntaxMacrosOld.MacroExpansionErrorMessage

@available(*, deprecated, message: "MacroExpansionWarningMessage has been moved to the SwiftSyntaxMacrosOld module")
public typealias MacroExpansionWarningMessage = SwiftSyntaxMacrosOld.MacroExpansionWarningMessage

@available(*, deprecated, message: "MacroExpansionFixItMessage has been moved to the SwiftSyntaxMacrosOld module")
public typealias MacroExpansionFixItMessage = SwiftSyntaxMacrosOld.MacroExpansionFixItMessage
