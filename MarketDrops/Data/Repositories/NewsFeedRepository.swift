import Foundation
import Combine
import MarketDropsAPIClient
import MarketDropsDomain
import Dependencies

struct NewsFeedRepository {
    var filings: (String) -> AnyPublisher<[CompanyFiling], LocalisedError>
    var news: (String) -> AnyPublisher<CompanyNews, LocalisedError>
    var favoured: (String) -> Bool
    var storeFavourite: (String, Bool) -> Void
}

extension NewsFeedRepository {
    static var live: Self = .init(
        filings: { symbol in
            DataController.shared.apiClient.execute(
                request: FetchCompanyFilingsRequest(
                    symbol: symbol,
                    fromDate: Date.days(by: -30)
                )
            ) 
            .map{ $0.map(CompanyFiling.init) }
            .mapError { LocalisedError.apiError($0) }
            .eraseToAnyPublisher()
        },
        news: { searchQuery in
            DataController.shared.apiClient.execute(
                request: FetchCompanyNewsRequest(searchQuery: searchQuery)
            )
            .map(CompanyNews.init)
            .mapError { LocalisedError.apiError($0) }
            .eraseToAnyPublisher()
        }, favoured: { symbol in
            UserPreferences.shared.isFavourite(for: symbol)
        }, storeFavourite: { (symbol, isFavoured) in
            UserPreferences.shared.add(symbol: symbol, isFavoured: isFavoured)
        }
    )
}

private enum NewsFeedRepositoryKey: DependencyKey {
    static let liveValue = NewsFeedRepository.live
}

extension DependencyValues {
    var newsFeedRepository: NewsFeedRepository {
        get { self[NewsFeedRepositoryKey.self] }
        set { self[NewsFeedRepositoryKey.self] = newValue }
    }
}
