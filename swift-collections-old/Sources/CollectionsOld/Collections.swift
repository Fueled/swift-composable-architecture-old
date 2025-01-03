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

#if !COLLECTIONS_SINGLE_MODULE
@_exported import BitCollectionsOld
@_exported import DequeModuleOld
@_exported import HashTreeCollectionsOld
@_exported import HeapModuleOld
@_exported import OrderedCollectionsOld
// Note: _RopeModuleOld is very intentionally not reexported, as its contents
// aren't part of this package's stable API surface (yet).
#endif
