import Foundation
import ComposableArchitecture
import MarketDropsRouting
import MarketDropsDomain

typealias NewsFeedStore = Store<NewsFeed.State, NewsFeed.Action>

enum NewsFeed {
    struct State: Equatable {
        var company: IPOCalendar.Company?
        var filings: Loading<[CompanyFiling]> = .idle
        var alert: AlertState<Action>?
        var favoured = false
    }

    enum Action: Equatable {
        case fetchFilings
        case didLoad(Result<[CompanyFiling], Error>)
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
            state.alert = .none
            state.filings = .loading(previous: .none)
            guard let symbol = state.company?.symbol else {
                return Effect(value: .didLoad(.success([])))
            }
            return environment.dataProvider.filings(symbol)
                .receive(on: environment.queue)
                .catchToEffect()
                .map(Action.didLoad)
                .eraseToEffect()

        case let .didLoad(.success(value)):
            state.filings = value.isEmpty ? .idle : .loaded(value) 
            return .none

        case let .didLoad(.failure(error)):
            state.filings = .error(AnyError(error))
            state.alert = .init(
                title: TextState("error_alert_title".localized),
                message: TextState(error.errorDescription ?? ""),
                dismissButton: .default(TextState("error_alert_cta".localized))
            )
            return .none
            
        case .didTapFavourite:
            state.favoured = !state.favoured
            return .none

        case .alertDismissed:
            state.alert = .none
            return .none
        }
    }
}
