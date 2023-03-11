import XCTest
import Combine
@testable import MarketDropsAPIClient

final class FetchCompanyNewsRequestTests: XCTestCase {
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
                path: "/v1/news/all",
                method: .get,
                statusCode: 201,
                data: FetchCompanyNewsRequest.dummy()
            )
        )
        
        let request = FetchCompanyNewsRequest(searchQuery: "AAPL")
        var output: MarketDropsAPIClient.CompanyNews?
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
        
        XCTAssertEqual(output?.articles.count, 3)
    }
}
