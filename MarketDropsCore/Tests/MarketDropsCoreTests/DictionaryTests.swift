import XCTest
@testable import MarketDropsCore

final class DictionaryTests: XCTestCase {
    func test_mergingReplacingValue() {
        var dictionary = ["a": 1, "b": 2, "c":3]
        dictionary.merge(other: ["a": 9])
        XCTAssertEqual(dictionary["a"], 9)
        XCTAssertEqual(dictionary["b"], 2)
        XCTAssertEqual(dictionary["c"], 3)
        XCTAssertEqual(dictionary.keys.count, 3)
    }
    
    func test_mergingAddingValue() {
        var dictionary = ["a": 1, "b": 2, "c":3]
        dictionary.merge(other: ["d": 4])
        XCTAssertEqual(dictionary["a"], 1)
        XCTAssertEqual(dictionary["b"], 2)
        XCTAssertEqual(dictionary["c"], 3)
        XCTAssertEqual(dictionary["d"], 4)
        XCTAssertEqual(dictionary.keys.count, 4)
    }
}
