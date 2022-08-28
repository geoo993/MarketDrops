import Foundation
import MarketDropsCore

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
    public var queryItems: [URLQueryItem]?
    public var queue: DispatchQueue = .main
    
    public init(fromDate: Date? = nil, toDate: Date? = nil) {
        headers = ["X-Finnhub-Token": self.provider.apiToken]
        guard let date1 = fromDate, let date2 = toDate else { return }
        let formatter = DateFormatter.date()
        queryItems = [
            URLQueryItem(name: "from", value: formatter.string(from: date1)),
            URLQueryItem(name: "to", value: formatter.string(from: date2))
        ]
    }
    
    
}

extension FetchIPOCalendarRequest: DummyProviding {}
