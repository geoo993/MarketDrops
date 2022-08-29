import Foundation
import MarketDropsCore

/// `GET /stock/filings?symbol=BIAF`
///
/// Fetches all companies SEC filings given a symbol
public struct FetchCompanyFilingsRequest: HTTPRequest {
    public typealias ResponseObject = [MarketDropsAPIClient.CompanyFiling]
    public typealias ErrorObject = MarketDropsAPIClient.Error
    public var provider: APIProvider { .finnhub }
    public var path: String { "/api/v1/stock/filings" }
    public var body: HTTPBody?
    public var headers: HTTPHeaders?
    public var queryItems: [URLQueryItem]?
    public var queue: DispatchQueue = .main
    
    public init(symbol: String, fromDate: Date? = nil) {
        headers = ["X-Finnhub-Token": self.provider.apiToken]
        var items = [URLQueryItem(name: "symbol", value: symbol)]
        if let date = fromDate {
            let formatter = DateFormatter.date()
            items.append(contentsOf: [
                URLQueryItem(name: "from", value: formatter.string(from: date))
            ])
        }
        queryItems = items
    }
}

extension FetchCompanyFilingsRequest: DummyProviding {}
