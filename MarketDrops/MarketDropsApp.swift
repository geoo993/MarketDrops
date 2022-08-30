import SwiftUI

@main
struct MarketDropsApp: App {
    private let router: TabBarRouter
    
    init() {
        let state: IPOs.State = .init(
            newsfeed: .init(company: nil)
        )
        router = TabBarRouter(
            store: .init(
                initialState: .init(
                    selectedTab: .ipos,
                    ipoCalendar: state,
                    favourites: .init(ipoCalendar: state)
                ),
                reducer: TabBar.reducer,
                environment: .init(
                    iposDataProcider: .live,
                    queue: .main
                )
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            router.contentView
        }
    }
}
