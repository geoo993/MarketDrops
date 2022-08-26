import SwiftUI
import CasePaths

final class IpoCalendarRouter {
    @ObservedObject var viewModel: IpoCalendarRouterViewModel
    
    init(viewModel: IpoCalendarRouterViewModel) {
        self.viewModel = viewModel
    }
}

extension IpoCalendarRouter: Router {
    var contentView: AnyView {
        AnyView (
            RoomOne {
                NewsFeedNavigation(viewModel: self.viewModel)
            }
        )
    }
}

struct NewsFeedNavigation: View {
    @ObservedObject var viewModel: IpoCalendarRouterViewModel
    
    var body: some View {
        NavigationLink(
            unwrap: $viewModel.route,
            case: /RoutePath.newsFeed,
            onNavigate: self.viewModel.setNewsFeedNavigation(isActive:),
            destination: { _ in
                NewsFeedRouter().contentView
            }) {
                Text("News Feed")
            }
    }
}
