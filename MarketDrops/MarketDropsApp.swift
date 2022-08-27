import SwiftUI

@main
struct MarketDropsApp: App {
    private let router: TabBarRouter
    
    init() {
        router = TabBarRouter(
            viewModel: .init(
                selectedTab: .ipos,
                ipoCalendarViewModel: .init()
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            router.contentView
        }
    }
}
