import Foundation
import SwiftUI
import MarketDropsRouting

final class NewsFeedRouter {
    @ObservedObject var viewModel: NewsFeedViewModel
    
    init(viewModel: NewsFeedViewModel = .init()) {
        self.viewModel = viewModel
    }
}

extension NewsFeedRouter: Router {
    var contentView: AnyView {
        AnyView (
            RoomFour()
        )
    }
}
