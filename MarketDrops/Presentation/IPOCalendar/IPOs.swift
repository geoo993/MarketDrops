import Foundation
import ComposableArchitecture
import MarketDropsRouting
import MarketDropsDomain

struct IPOs: ReducerProtocol {
    struct State: Equatable {
        var newsfeed: NewsFeed.State
        var route: IpoRoutePath?
        var calendar: Loading<IPOCalendar> = .idle
        var alert: AlertState<Action>?
        var companiesAvailable: Bool {
            guard let companies = calendar.loaded?.companies else {
                return false
            }
            return !companies.isEmpty
        }
    }

    enum Action: Equatable {
        case fetchIpoCalendar
        case didSelectRoute(Bool, IPOCalendar.Company)
        case onNavigate(IpoRoutePath?)
        case didLoad(Result<IPOCalendar, LocalisedError>)
        case alertDismissed
        case newsfeed(NewsFeed.Action)
    }

    @Dependency(\.iposRepository) var repository: IPOsRepository
    @Dependency(\.mainQueue) var queue
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.newsfeed, action: /Action.newsfeed) {
            NewsFeed()
        }
        Reduce { state, action in
            switch action {
            case .fetchIpoCalendar:
                state.calendar = .loading(previous: .none)
                state.alert = .none
                return self.repository.calendar()
                    .receive(on: self.queue)
                    .catchToEffect()
                    .map(Action.didLoad)
                    .eraseToEffect()
                
            case let .didSelectRoute(isActive, company):
                return EffectTask(value: .onNavigate(isActive ? .company(company) : nil))
                
            case let .onNavigate(value):
                state.newsfeed.company = (/IpoRoutePath.company).extract(from: value)
                state.route = value
                return .none
                
            case let .didLoad(.success(value)):
                state.calendar = .loaded(value)
                return .none
                
            case let .didLoad(.failure(error)):
                HapticFeedback.failure.play()
                state.calendar = .error(AnyError(error))
                state.alert = .errorAlert(error.errorDescription ?? "")
                return .none
                
            case .alertDismissed:
                state.alert = .none
                return .none
                
            case .newsfeed:
                return .none
            }
        }
    }
}
