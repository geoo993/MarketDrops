import XCTest
@testable import MarketDropsRouting

final class DeeplinkParserTests: XCTestCase {
    
    func test_deeplinkParserFails() throws {
        let url = try XCTUnwrap(URL(string: "applink:///hello"))
        let parser = DeeplinkParser(url: url)
        let routeData = try XCTUnwrap(RouteData(deeplinkParser: parser))
        XCTAssertEqual(routeData.path, .unsupported)
    }
    
    func test_ipoCalendarDeeplink() throws {
        let url = try XCTUnwrap(URL(string: "applink:///ipo"))
        let parser = DeeplinkParser(url: url)
        let routeData = try XCTUnwrap(RouteData(deeplinkParser: parser))
        XCTAssertEqual(routeData.path, .ipoCalendar(nil))
    }
    
    func test_favouritesDeeplink() throws {
        let url = try XCTUnwrap(URL(string: "applink:///favourites"))
        let parser = DeeplinkParser(url: url)
        let routeData = try XCTUnwrap(RouteData(deeplinkParser: parser))
        XCTAssertEqual(routeData.path, .favourites)
    }
    
    func test_newsfeedDeeplink() throws {
        let url = try XCTUnwrap(URL(string: "applink:///ipo?feed=AAPL"))
        let parser = DeeplinkParser(url: url)
        let routeData = try XCTUnwrap(RouteData(deeplinkParser: parser))
        XCTAssertEqual(routeData.path, .ipoCalendar(.newsFeed("AAPL")))
    }
}
