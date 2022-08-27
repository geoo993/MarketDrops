import SwiftUI
import MarketDropsRouting

final class TabBarRouter {
    private let tabBarView: TabBarView
    private let tabBarViewModel: TabBarViewModel
    
    init(viewModel: TabBarViewModel) {
        self.tabBarViewModel = viewModel
        self.tabBarView = TabBarView(
            viewModel: viewModel,
            tabRoutings: TabItem.allCases.map { item -> TabRouting in
                switch item {
                case .ipos:
                    return TabRouting(
                        item: item,
                        router: IpoCalendarRouter(viewModel: viewModel.ipoCalendarViewModel)
                    )
                case .favourites:
                    return TabRouting(item: item, router: FavouritesRouter())
                }
            }
        )
    }
}

extension TabBarRouter: Router {
    var contentView: AnyView {
        AnyView (
            tabBarView
                .onOpenURL { url in
                    self.tabBarViewModel.open(url: url)
                }
        )
    }
}
