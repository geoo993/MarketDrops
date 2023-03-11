import Foundation
import ComposableArchitecture
import MarketDropsRouting
import MarketDropsDomain

struct Favourites: ReducerProtocol {
    struct State: Equatable {
        var loadedIpos: Loading<IPOCalendar> = .idle
        var ipoCalendar: IPOs.State
    }

    enum Action: Equatable {
        case fetchFavourites
        case latest(Result<IPOCalendar, LocalisedError>)
        case ipoCalendar(IPOs.Action)
    }

    @Dependency(\.favouritesRepository) var repository: FavouritesRepository
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.ipoCalendar, action: /Action.ipoCalendar) {
            IPOs()
        }
        Reduce { state, action in
            switch action {
            case .ipoCalendar:
                return .none
                
            case .fetchFavourites:
                guard let companies = state.loadedIpos.loaded?.companies else { return .none }
                let favourites = self.repository.favouredList()
                let values = companies.filter { favourites.contains($0.symbol) }
                state.ipoCalendar.calendar = .loaded(.init(companies: values))
                return .none
                
            case let .latest(result):
                state.loadedIpos = Loading.from(result: result)
                return .none
            }
        }
    }
}
