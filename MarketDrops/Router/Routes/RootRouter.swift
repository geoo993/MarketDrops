import SwiftUI

final class RootRouter {
    private let tabBarView: TabBarView
    private let tabBarViewModel: TabBarViewModel
    
    init(viewModel: TabBarViewModel = .init()) {
        self.tabBarViewModel = viewModel
        self.tabBarView = TabBarView(
            viewModel: viewModel,
            tabRoutings: TabItem.allCases.map { item -> TabRouting in
                switch item {
                case .ipos:
                    return TabRouting(item: item, router: IpoCalendarRouter(viewModel: .init()))
                case .favourites:
                    return TabRouting(item: item, router: FavouritesRouter())
                case .profile:
                    return TabRouting(item: item, router: ProfileRouter())
                }
            }
        )
    }
}

extension RootRouter: Router {
    var contentView: AnyView {
        AnyView (
            tabBarView
                .onOpenURL { url in
                    self.tabBarViewModel.open(url: url)
                }
        )
    }
}
