import Foundation
import Combine
import MarketDropsAPIClient
import MarketDropsDomain

extension NewsFeed {
    enum Error: LocalizedError, Equatable {
        case apiError(MarketDropsAPIClient.Error)
        
        var errorDescription: String? {
            switch self {
            case let .apiError(error):
                return "error_alert_description".localized(arguments: error.localizedDescription)
            }
        }
    }
    
    struct DataProvider {
        var filings: (String) -> AnyPublisher<[CompanyFiling], Error>
        var news: (String) -> AnyPublisher<CompanyNews, Error>
        var favoured: (String) -> Bool
        var storeFavourite: (String, Bool) -> Void
    }
}

extension NewsFeed.DataProvider {
    static var live: Self = .init(
        filings: { symbol in
            DataController.shared.apiClient.execute(
                request: FetchCompanyFilingsRequest(
                    symbol: symbol,
                    fromDate: Date.days(by: -30)
                )
            ) 
            .map{ $0.map(CompanyFiling.init) }
            .mapError { NewsFeed.Error.apiError($0) }
            .eraseToAnyPublisher()
        },
        news: { searchQuery in
            DataController.shared.apiClient.execute(
                request: FetchCompanyNewsRequest(searchQuery: searchQuery)
            )
            .map(CompanyNews.init)
            .mapError { NewsFeed.Error.apiError($0) }
            .eraseToAnyPublisher()
        }, favoured: { symbol in
            UserPreferences.shared.isFavourite(for: symbol)
        }, storeFavourite: { (symbol, isFavoured) in
            UserPreferences.shared.add(symbol: symbol, isFavoured: isFavoured)
        }
    )
}
