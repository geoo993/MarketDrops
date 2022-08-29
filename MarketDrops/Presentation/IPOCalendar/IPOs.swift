import Foundation
import ComposableArchitecture
import MarketDropsRouting
import MarketDropsDomain

typealias IPOsStore = Store<IPOs.State, IPOs.Action>
typealias IPOsViewStore = ViewStore<IPOs.State, IPOs.Action>

enum IPOs {
    struct State: Equatable {
        var newsfeed: NewsFeed.State
        var route: IpoRoutePath?
        var calendar: Loading<IPOCalendar> = .idle
        var alert: AlertState<Action>?
    }

    enum Action: Equatable {
        case fetchIpoCalendar
        case didSelectRoute(Bool, IPOCalendar.Company)
        case onNavigate(IpoRoutePath?)
        case didLoad(Result<IPOCalendar, Error>)
        case alertDismissed
        case newsfeed(NewsFeed.Action)
    }

    struct Environment {
        let dataProvider: DataProvider
        let queue: AnySchedulerOf<DispatchQueue>
    }
    
    static let reducer: Reducer<State, Action, Environment> = .combine(
        NewsFeed.reducer.pullback(
            state: \.newsfeed,
            action: /Action.newsfeed,
            environment: {
                .init(
                    dataProvider: .live,
                    queue: $0.queue
                )
            }
        ),
        .init { state, action, environment in
            switch action {
            case .fetchIpoCalendar:
                state.calendar = .loading(previous: .none)
                state.alert = .none
                return environment.dataProvider.calendar()
                    .receive(on: environment.queue)
                    .catchToEffect()
                    .map(Action.didLoad)
                    .eraseToEffect()
        
            case let .didSelectRoute(isActive, company):
                return Effect(value: .onNavigate(isActive ? .company(company) : nil))
                
            case let .onNavigate(value):
                state.newsfeed.company = (/IpoRoutePath.company).extract(from: value)
                state.route = value
                return .none
                
            case let .didLoad(.success(value)):
                state.calendar = .loaded(value)
                return .none
                
            case let .didLoad(.failure(error)):
                state.calendar = .error(AnyError(error))
                state.alert = .init(
                    title: TextState("error_alert_title".localized),
                    message: TextState(error.errorDescription ?? ""),
                    dismissButton: .default(TextState("error_alert_cta".localized))
                )
                return .none
                
            case .alertDismissed:
                state.alert = .none
                return .none
                
            case .newsfeed:
                return .none
            }
        }
    )
}
