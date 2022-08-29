import Foundation
import MarketDropsDomain

extension CompanyNews {
    public static func fixture(
        pagination: Pagination = .fixture(),
        articles: [Article] = []
    ) -> Self {
        .init(pagination: pagination, articles: articles)
    }
}

extension CompanyNews.Pagination {
    public static func fixture() -> Self {
        .init(found: 23, returned: 3, limit: 3, page: 1)
    }
}

extension CompanyNews.Article {
    public static func fixture(
        id: String = "abcdefg",
        title: String = "Apple",
        description: String = "This is Apple",
        snippet: String = "Apple new iPhone",
        url: URL? = URL(string: "https://investmentu.com/hempacco-ipo/")!,
        image: URL? = URL(string: "https://investmentu.com/wp-content/uploads/2022/08/hempacco-ipo.jpg")!,
        publishedAt: Date = .init(),
        source: String = "The republic"
    ) -> Self {
        .init(
            id: id,
            title: title,
            description: description,
            snippet: snippet,
            url: url,
            image: image,
            publishedAt: publishedAt,
            source: source
        )
    }
}
