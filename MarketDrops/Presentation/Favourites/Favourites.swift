import Foundation
import ComposableArchitecture
import MarketDropsRouting
import MarketDropsDomain

typealias FavouritesStore = Store<Favourites.State, Favourites.Action>
typealias FavouritesViewStore = ViewStore<Favourites.State, Favourites.Action>

enum Favourites {
    struct State: Equatable {
        var loadedIpos: Loading<IPOCalendar> = .idle
        var ipoCalendar: IPOs.State
    }

    enum Action: Equatable {
        case fetchFavourites
        case latest(Result<IPOCalendar, IPOs.Error>)
        case ipoCalendar(IPOs.Action)
    }

    struct Environment {
        let dataProvider: DataProvider
        let iposDataProvider: IPOs.DataProvider
        let queue: AnySchedulerOf<DispatchQueue>
    }
    
    static let reducer: Reducer<State, Action, Environment> = .combine(
        IPOs.reducer.pullback(
            state: \.ipoCalendar,
            action: /Action.ipoCalendar,
            environment: {
                .init(
                    dataProvider: $0.iposDataProvider,
                    queue: $0.queue
                )
            }
        ),
        .init { state, action, environment in
            switch action {
            case .ipoCalendar:
                return .none
                
            case .fetchFavourites:
                guard let companies = state.loadedIpos.loaded?.companies else { return .none }
                let favourites = environment.dataProvider.favouredList()
                let values = companies.filter { favourites.contains($0.symbol) }
                state.ipoCalendar.calendar = .loaded(.init(companies: values))
                return .none
                
            case let .latest(result):
                state.loadedIpos = Loading.from(result: result)
                return .none
            }
        }
    )
}
