import SwiftUI

@main
struct MarketDropsApp: App {
    private let router: TabBarRouter
    
    init() {
        router = TabBarRouter(
            store: .init(
                initialState: .init(
                    selectedTab: .ipos,
                    ipoCalendar: .init()
                ),
                reducer: TabBar.reducer,
                environment: .init(queue: .main)
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            router.contentView
        }
    }
}
