import Foundation
import MarketDropsRouting
import ComposableArchitecture

typealias TabBarStore = Store<TabBar.State, TabBar.Action>
typealias TabBarViewStore = ViewStore<TabBar.State, TabBar.Action>

enum TabBar {
    struct State: Equatable {
        var selectedTab: TabItem
        var ipoCalendar: IPOs.State
        var favourites: Favourites.State
    }

    enum Action: Equatable {
        case ipoCalendar(IPOs.Action)
        case favourites(Favourites.Action)
        case didSelectTab(TabItem)
        case open(URL)
    }

    struct Environment {
        let iposDataProcider: IPOs.DataProvider
        let queue: AnySchedulerOf<DispatchQueue>
    }
    
    static let reducer: Reducer<State, Action, Environment> = .combine(
        IPOs.reducer.pullback(
            state: \.ipoCalendar,
            action: /Action.ipoCalendar,
            environment: {
                .init(
                    dataProvider: $0.iposDataProcider,
                    queue: $0.queue
                )
            }
        ),
        Favourites.reducer.pullback(
            state: \.favourites,
            action: /Action.favourites,
            environment: {
                .init(
                    dataProvider: .live,
                    iposDataProvider: $0.iposDataProcider,
                    queue: $0.queue
                )
            }
        ),
        .init { state, action, environment in
            switch action {
            case .favourites:
                return .none
                
            case let .ipoCalendar(.didLoad(result)):
                return Effect(value: .favourites(.latest(result)))

            case let .didSelectTab(tab):
                state.selectedTab = tab
                return .none
                
            case let .open(url):
                let routeData = RouteData(deeplinkParser: .init(url: url))
                switch routeData?.path {
                case let .ipoCalendar(path):
                    return Effect.merge(
                        Effect(value: .didSelectTab(.ipos)),
                        Effect(value: .ipoCalendar(.onNavigate(path)))
                    )
                case .favourites:
                    return Effect(value: .didSelectTab(.favourites))
                case .unsupported, .none:
                    return .none
                }
                
            default:
                return .none
            }
        }
    )
}
