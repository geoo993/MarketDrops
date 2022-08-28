import XCTest
import MarketDropsDomain
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
        let url = try XCTUnwrap(URL(string: "applink:///ipo?id=abcde&symbol=HPCO&date=2022-08-30&status=expected"))
        let parser = DeeplinkParser(url: url)
        let routeData = try XCTUnwrap(RouteData(deeplinkParser: parser))
        let date = try XCTUnwrap(DateFormatter.date().date(from: "2022-08-30"))
        XCTAssertEqual(
            routeData.path,
            .ipoCalendar(.company(
                .init(
                    id: "abcde",
                    name: "",
                    symbol: "HPCO",
                    date: date,
                    status: .expected(exchange: nil),
                    price: nil
                )
            ))
        )
    }
}
