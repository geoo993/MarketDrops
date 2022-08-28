import XCTest
@testable import MarketDropsAPIClient

final class FetchIPOCalendarRequestTests: XCTestCase {
    var apiClient: MarketDropsAPIClient!
    var session: MockHTTPSession!
        
    override func setUp() {
        super.setUp()
        session = MockHTTPSession()
        apiClient = MarketDropsAPIClient(
            session: session,
            networkMonitor: MockNetworkMonitor(isConnected: true)
        )
    }

    override func tearDown() {
        session = nil
        apiClient = nil
        super.tearDown()
    }
    
    func test_request() throws {
        session.register(
            stub: MockHTTPSession.Stub(
                path: "/api/v1/calendar/ipo",
                method: .get,
                statusCode: 201,
                data: FetchIPOCalendarRequest.dummy()
            )
        )
        let request = FetchIPOCalendarRequest()
        let result = try result(apiClient.execute(request: request))
        XCTAssertEqual(result.companies.count, 3)
    }
}
