import XCTest
@testable import MarketDropsCore

final class OptionalTests: XCTestCase {
    func test_isNilOrEmpty() {
        var value: String?
        XCTAssertTrue(value.isNilOrEmpty)
        
        value = ""
        XCTAssertTrue(value.isNilOrEmpty)
        
        value = "Hello, World!"
        XCTAssertFalse(value.isNilOrEmpty)
    }
    
    func test_isNilAndNotNil() {
        var value: String?
        XCTAssertTrue(value.isNil)
        
        value = "Hello, World!"
        XCTAssertTrue(value.isNotNil)
    }
    
    func test_stringToUrl() {
        var value: String?
        XCTAssertNil(value.toUrl)
        
        value = "www.google.com"
        let result = value.toUrl
        XCTAssertNotNil(value.toUrl)
        XCTAssertEqual(result, URL(string: "www.google.com"))
    }
}
