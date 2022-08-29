import Foundation

public extension MarketDropsAPIClient {
    struct CompanyNews: Decodable {
        public let pagination: Pagination
        public let articles: [Article]
        
        enum CodingKeys: String, CodingKey {
            case pagination = "meta"
            case articles = "data"
        }
    }
}

public extension MarketDropsAPIClient.CompanyNews {
    struct Pagination: Decodable {
        public let found: Int
        public let returned: Int
        public let limit: Int
        public let page: Int
    }
}

public extension MarketDropsAPIClient.CompanyNews {
    struct Article: Decodable {
        public let id: String
        public let title: String
        public let description: String
        public let snippet: String
        public let url: String
        public let image: String
        public let publishedAt: Date
        public let source: String
        
        enum CodingKeys: String, CodingKey {
            case id = "uuid"
            case title
            case description
            case snippet
            case url
            case image = "image_url"
            case publishedAt = "published_at"
            case source
        }
    }
}
