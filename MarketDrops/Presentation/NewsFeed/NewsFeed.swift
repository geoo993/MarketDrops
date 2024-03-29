import Foundation
import ComposableArchitecture
import MarketDropsRouting
import MarketDropsDomain

typealias NewsFeedStore = Store<NewsFeed.State, NewsFeed.Action>
typealias NewsFeedViewStore = ViewStore<NewsFeed.State, NewsFeed.Action>

enum NewsFeed {
    struct State: Equatable {
        var company: IPOCalendar.Company?
        var filings: Loading<[CompanyFiling]> = .idle
        var news: Loading<CompanyNews> = .idle
        var alert: AlertState<Action>?
        var isFavoured = false
    }

    enum Action: Equatable {
        case fetchFilings
        case didLoadFilings(Result<[CompanyFiling], Error>)
        case fetchNews
        case didLoadNews(Result<CompanyNews, Error>)
        case didTapFavourite
        case alertDismissed
    }

    struct Environment {
        let dataProvider: DataProvider
        let queue: AnySchedulerOf<DispatchQueue>
    }
    
    static let reducer: Reducer<State, Action, Environment> = .init { state, action, environment in
        switch action {
        case .fetchFilings:
            guard let symbol = state.company?.symbol else {
                return Effect(value: .didLoadFilings(.success([])))
            }
            state.alert = .none
            state.filings = .loading(previous: .none)
            state.isFavoured = environment.dataProvider.favoured(symbol)
            return environment.dataProvider.filings(symbol)
                .receive(on: environment.queue)
                .catchToEffect()
                .map(Action.didLoadFilings)
                .eraseToEffect()

        case let .didLoadFilings(.success(value)):
            state.filings = value.isEmpty ? .idle : .loaded(value)
            return .none

        case let .didLoadFilings(.failure(error)):
            HapticFeedback.failure.play()
            state.filings = .error(AnyError(error))
            state.alert = .errorAlert(error.errorDescription ?? "")
            return .none
        
        case .fetchNews:
            state.alert = .none
            state.news = .loading(previous: .none)
            guard let symbol = state.company?.symbol else {
                state.news = .idle
                return .none
            }
            return environment.dataProvider.news(symbol)
                .receive(on: environment.queue)
                .catchToEffect()
                .map(Action.didLoadNews)
                .eraseToEffect()
            
        case let .didLoadNews(.success(value)):
            state.news = value.articles.isEmpty ? .idle : .loaded(value)
            return .none

        case let .didLoadNews(.failure(error)):
            HapticFeedback.failure.play()
            state.news = .error(AnyError(error))
            state.alert = .errorAlert(error.errorDescription ?? "")
            return .none
            
        case .didTapFavourite:
            if let symbol = state.company?.symbol {
                state.isFavoured = !state.isFavoured
                environment.dataProvider.storeFavourite(symbol, state.isFavoured)
            }
            return .none

        case .alertDismissed:
            state.alert = .none
            return .none
        }
    }
}
