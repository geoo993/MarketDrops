import SwiftUI
import MarketDropsRouting
import ComposableArchitecture

final class TabBarRouter {
    private let store: TabBarStore
    @ObservedObject var viewStore: TabBarViewStore
    
    init(store: TabBarStore) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
}

extension TabBarRouter: Router {
    var contentView: AnyView {
        AnyView (
            TabBarView(
                viewStore: viewStore,
                tabRoutings: TabItem.allCases.map { item -> TabRouting in
                    switch item {
                    case .ipos:
                        return TabRouting(
                            item: item,
                            router: IpoCalendarRouter(
                                store: self.store.scope(
                                    state: \.ipoCalendar,
                                    action: TabBar.Action.ipoCalendar
                                )
                            )
                        )
                    case .favourites:
                        return TabRouting(
                            item: item,
                            router: FavouritesRouter(
                                store: self.store.scope(
                                    state: \.favourites,
                                    action: TabBar.Action.favourites
                                )
                            )
                        )
                    }
                }
            )
            .onOpenURL { url in
                self.viewStore.send(.open(url))
            }
            .onAppear {
                self.viewStore.send(.ipoCalendar(.fetchIpoCalendar))
            }
        )
    }
}
