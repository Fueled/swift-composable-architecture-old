import SnapshotTestingOld
import XCTest

final class DeprecationTests: XCTestCase {
  @available(*, deprecated)
  func testIsRecordingProxy() {
    SnapshotTestingOld.record = true
    XCTAssertEqual(isRecording, true)

    SnapshotTestingOld.record = false
    XCTAssertEqual(isRecording, false)
  }
}
