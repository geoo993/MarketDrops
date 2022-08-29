import XCTest
@testable import MarketDropsCore

final class DateFormatterTests: XCTestCase {
    func test_dateFormatFails() {
        let dateString = "20-10-2022"
        let date = DateFormatter.date().date(from: dateString)
        XCTAssertNil(date)
    }
    
    func test_dateFormatSucceeds() throws {
        let dateString = "2022-10-21"
        let formatter = DateFormatter.date()
        let date = try XCTUnwrap(formatter.date(from: dateString))
        let result = formatter.string(from: date)
        XCTAssertEqual(result, dateString)
    }
    
    func test_dateShortHandFails() {
        let dateString = "20-10-2022"
        let date = DateFormatter.shortHand().date(from: dateString)
        XCTAssertNil(date)
    }
    
    func test_dateShortHandSucceed() throws {
        let dateString = "2022-10-21"
        let date = try XCTUnwrap(DateFormatter.date().date(from: dateString))
        let result = DateFormatter.shortHand().string(from: date)
        XCTAssertEqual(result, "Oct 21, 2022")
    }
    
    func test_dateAndTimeFails() {
        let dateString = "20-10-2022 12:45:24"
        let date = DateFormatter.dateAndTime().date(from: dateString)
        XCTAssertNil(date)
    }
    
    func test_dateAndTimeSucceeds() throws {
        let dateString = "2022-08-23 14:13:01"
        let formatter = DateFormatter.dateAndTime()
        let date = try XCTUnwrap(formatter.date(from: dateString))
        let result = formatter.string(from: date)
        XCTAssertEqual(result, dateString)
    }
    
    func test_iso8601DateFails() {
        let dateString = "20-10-2022T12:45:24.000000Z"
        let date = ISO8601DateFormatter.iso8601Full().date(from: dateString)
        XCTAssertNil(date)
    }
    
    func test_iso8601DateSucceeds() throws {
        let dateString = "2022-06-17T23:36:42.000Z"
        let formatter = ISO8601DateFormatter.iso8601Full()
        let date = try XCTUnwrap(formatter.date(from: dateString))
        let result = formatter.string(from: date)
        XCTAssertEqual(result, dateString)
    }
}
