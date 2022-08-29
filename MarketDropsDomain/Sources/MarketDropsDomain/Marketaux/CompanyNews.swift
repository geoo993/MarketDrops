import Foundation

public struct CompanyNews: Equatable {
    public let pagination: Pagination
    public let articles: [Article]
    
    public init(pagination: Pagination, articles: [Article]) {
        self.pagination = pagination
        self.articles = articles
    }
}

public extension CompanyNews {
    struct Pagination: Equatable {
        public let found: Int
        public let returned: Int
        public let limit: Int
        public let page: Int
        
        public init(found: Int, returned: Int, limit: Int, page: Int) {
            self.found = found
            self.returned = returned
            self.limit = limit
            self.page = page
        }
    }
}

public extension CompanyNews {
    struct Article: Equatable, Identifiable {
        public let id: String
        public let title: String
        public let description: String
        public let snippet: String
        public let url: URL?
        public let image: URL?
        public let publishedAt: Date
        public let source: String
        
        public init(
            id: String,
            title: String,
            description: String,
            snippet: String,
            url: URL?,
            image: URL?,
            publishedAt: Date,
            source: String
        ) {
            self.id = id
            self.title = title
            self.description = description
            self.snippet = snippet
            self.url = url
            self.image = image
            self.publishedAt = publishedAt
            self.source = source
        }
    }
}
