// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import BenchmarkOld
import BenchmarkSuiteExample
import XCTest

final class BenchmarkSuiteTests: XCTestCase {
    // A single catch-all test for macOS. 
    func testBenchmarks() {
        BenchmarkOld.runTests(suites: BenchmarkSuiteExample.suites)
    }

    // A more fine-grain per-benchmark tests used outside of macOS. 
    static var allTests = BenchmarkOld.makeTests(
        BenchmarkSuiteTests.self, suites: BenchmarkSuiteExample.suites)
}
