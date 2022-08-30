import SwiftUI
import MarketDropsRouting
import MarketDropsDomain
import ComposableArchitecture

final class FavouritesRouter {
    private let store: FavouritesStore
    private var color = Color(UIColor.systemBackground)

    init(store: FavouritesStore) {
        self.store = store
    }
}

extension FavouritesRouter: Router {
    var contentView: AnyView {
        AnyView (
            WithViewStore(self.store) { viewStore in
                Room(color: self.color) {
                    IPOCalendarView(
                        store: self.store.scope(
                            state: \.ipoCalendar,
                            action: Favourites.Action.ipoCalendar
                        ),
                        color: self.color,
                        emptyStateTitle: "favourites__emptyStateTitle".localized
                    )
                }
                .navigationBarTitle("favourites__screen")
                .onAppear {
                    viewStore.send(.fetchFavourites)
                }
            }
        )
    }
}
