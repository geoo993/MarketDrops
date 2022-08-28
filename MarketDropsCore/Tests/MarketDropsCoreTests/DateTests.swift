import XCTest
@testable import MarketDropsCore

final class DateTests: XCTestCase {
    func test_dateByNegative() throws {
        let dateString = "2022-10-21"
        let currentDate = try XCTUnwrap(DateFormatter.date().date(from: dateString))
        let date = try XCTUnwrap(Date.days(by: -14, currentDate: currentDate))
        let result = DateFormatter.date().string(from: date)
        XCTAssertEqual(result, "2022-10-07")
    }
    
    func test_dateByPossitive() throws {
        let dateString = "2022-10-21"
        let currentDate = try XCTUnwrap(DateFormatter.date().date(from: dateString))
        let date = try XCTUnwrap(Date.days(by: 7, currentDate: currentDate))
        let result = DateFormatter.date().string(from: date)
        XCTAssertEqual(result, "2022-10-28")
    }
}
