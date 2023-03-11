import Foundation
import MarketDropsRouting
import ComposableArchitecture

struct TabBar: ReducerProtocol {
    struct State: Equatable {
        var selectedTab: TabItem = .ipos
        var ipoCalendar: IPOs.State
        var favourites: Favourites.State
    }

    enum Action: Equatable {
        case ipoCalendar(IPOs.Action)
        case favourites(Favourites.Action)
        case didSelectTab(TabItem)
        case open(URL)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.ipoCalendar, action: /Action.ipoCalendar) {
            IPOs()
        }
        Scope(state: \.favourites, action: /Action.favourites) {
            Favourites()
        }
        Reduce { state, action in
            switch action {
            case .favourites:
                return .none
                
            case let .ipoCalendar(.didLoad(result)):
                return EffectTask(value: .favourites(.latest(result)))
                
            case let .didSelectTab(tab):
                HapticFeedback.selection.play()
                state.selectedTab = tab
                return .none
                
            case let .open(url):
                let routeData = RouteData(deeplinkParser: .init(url: url))
                switch routeData?.path {
                case let .ipoCalendar(path):
                    return EffectTask.merge(
                        EffectTask(value: .didSelectTab(.ipos)),
                        EffectTask(value: .ipoCalendar(.onNavigate(path)))
                    )
                case .favourites:
                    return EffectTask(value: .didSelectTab(.favourites))
                case .unsupported, .none:
                    return .none
                }
                
            default:
                return .none
            }
        }
    }
}
