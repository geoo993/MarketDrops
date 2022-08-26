import SwiftUI

@main
struct MarketDropsApp: App {

    let router: RootRouter
    
    init() {
        router = RootRouter()
    }

    var body: some Scene {
        WindowGroup {
            router.contentView
        }
    }
}
