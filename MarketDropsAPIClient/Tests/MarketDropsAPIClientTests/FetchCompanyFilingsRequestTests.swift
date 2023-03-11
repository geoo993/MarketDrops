import XCTest
import Combine
@testable import MarketDropsAPIClient

final class FetchCompanyFilingsRequestTests: XCTestCase {
    private var apiClient: MarketDropsAPIClient!
    private var session: MockHTTPSession!
    private var cancellables = Set<AnyCancellable>()
    
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
                path: "/api/v1/stock/filings",
                method: .get,
                statusCode: 201,
                data: FetchCompanyFilingsRequest.dummy()
            )
        )
        
        let request = FetchCompanyFilingsRequest(symbol: "AAPL")
        var output = [MarketDropsAPIClient.CompanyFiling]()
        let expectation = XCTestExpectation(description: "Completion")
        apiClient.execute(request: request)
            .sinkToResult { result in
                switch result {
                case let .success(value):
                    output = value
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                }
                expectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(output.count, 2)
    }
}
