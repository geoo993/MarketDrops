import Foundation
import ComposableArchitecture
import MarketDropsRouting
import MarketDropsDomain

struct NewsFeed: ReducerProtocol {
    struct State: Equatable {
        var company: IPOCalendar.Company?
        var filings: Loading<[CompanyFiling]> = .idle
        var news: Loading<CompanyNews> = .idle
        var alert: AlertState<Action>?
        var isFavoured = false
    }

    enum Action: Equatable {
        case fetchFilings
        case didLoadFilings(Result<[CompanyFiling], LocalisedError>)
        case fetchNews
        case didLoadNews(Result<CompanyNews, LocalisedError>)
        case didTapFavourite
        case alertDismissed
    }

    @Dependency(\.newsFeedRepository) var repository: NewsFeedRepository
    @Dependency(\.mainQueue) var queue
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchFilings:
                guard let symbol = state.company?.symbol else {
                    return EffectTask(value: .didLoadFilings(.success([])))
                }
                state.alert = .none
                state.filings = .loading(previous: .none)
                state.isFavoured = self.repository.favoured(symbol)
                return self.repository.filings(symbol)
                    .receive(on: self.queue)
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
                return self.repository.news(symbol)
                    .receive(on: self.queue)
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
                    self.repository.storeFavourite(symbol, state.isFavoured)
                }
                return .none
                
            case .alertDismissed:
                state.alert = .none
                return .none
            }
        }
    }
}
