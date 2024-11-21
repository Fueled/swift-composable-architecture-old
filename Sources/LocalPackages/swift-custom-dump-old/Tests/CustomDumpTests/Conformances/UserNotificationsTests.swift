#if canImport(UserNotifications)
  import CustomDumpOld
  import XCTest
  import UserNotifications

  class UserNotificationsTests: XCTestCase {
    func testUNAuthorizationOptions() {
      var dump: String = ""
      customDump([.badge, .alert] as UNAuthorizationOptions, to: &dump)
      XCTAssertEqual(
        dump,
        """
        Set([
          UNAuthorizationOptions.alert,
          UNAuthorizationOptions.badge
        ])
        """
      )
    }
  }
#endif