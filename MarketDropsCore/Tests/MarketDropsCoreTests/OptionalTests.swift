import XCTest
@testable import MarketDropsCore

final class OptionalTests: XCTestCase {
    func testIsNilOrEmpty() {
        var value: String?
        XCTAssertTrue(value.isNilOrEmpty)
        
        value = ""
        XCTAssertTrue(value.isNilOrEmpty)
        
        value = "Hello, World!"
        XCTAssertFalse(value.isNilOrEmpty)
    }
    
    func testIsNilAndNotNil() {
        var value: String?
        XCTAssertTrue(value.isNil)
        
        value = "Hello, World!"
        XCTAssertTrue(value.isNotNil)
    }
}
