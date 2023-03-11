import SwiftUI
import ComposableArchitecture

@main
struct MarketDropsApp: App {
    private let router: TabBarRouter
    
    init() {
        let state: IPOs.State = .init(
            newsfeed: .init(company: nil)
        )
        router = TabBarRouter(
            store: Store(
                initialState: TabBar.State(
                    selectedTab: .ipos,
                    ipoCalendar: state,
                    favourites: .init(ipoCalendar: state)
                ),
                reducer: TabBar()
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            router.contentView
        }
    }
}
