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
}