import Foundation
import MarketDropsCore

/// `GET /v1/news/all?search=AAPL`
///
/// Fetches company ipo news with given search query
public struct FetchCompanyNewsRequest: HTTPRequest {
    public typealias ResponseObject = MarketDropsAPIClient.CompanyNews
    public typealias ErrorObject = MarketDropsAPIClient.Error
    public var provider: APIProvider { .marketaux }
    public var path: String { "/v1/news/all" }
    public var body: HTTPBody?
    public var headers: HTTPHeaders?
    public var queryItems: [URLQueryItem]?
    public var queue: DispatchQueue = .main
    
    public init(searchQuery: String) {
        queryItems = [
            URLQueryItem(name: "api_token", value: self.provider.apiToken),
            URLQueryItem(name: "search", value: searchQuery)
        ]
    }
}

extension FetchCompanyNewsRequest: DummyProviding {}
