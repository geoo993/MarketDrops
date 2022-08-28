import Foundation

/// `GET /calendar/ipo`
///
/// Fetches all companies in ipo calendar witin the given dates
public struct FetchIPOCalendarRequest: HTTPRequest {
    public typealias ResponseObject = MarketDropsAPIClient.IPOCalandar
    public typealias ErrorObject = MarketDropsAPIClient.Error
    public var provider: APIProvider { .finnhub }
    public var path: String { "/api/v1/calendar/ipo" }
    public var body: HTTPBody?
    public var headers: HTTPHeaders?
    public var queue: DispatchQueue = .main
    
    public init() {
        headers = ["X-Finnhub-Token": self.provider.apiToken]
    }
}

extension FetchIPOCalendarRequest: DummyProviding {}
