import SwiftUI
import CasePaths
import MarketDropsRouting

final class IpoCalendarRouter {
    @ObservedObject var viewModel: IpoCalendarViewModel
    
    init(viewModel: IpoCalendarViewModel) {
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
    @ObservedObject var viewModel: IpoCalendarViewModel
    
    var body: some View {
        NavigationLink(
            unwrap: $viewModel.route,
            case: /RoutePath.ipoCalendar,
            onNavigate: self.viewModel.setNewsFeedNavigation(isActive:),
            destination: { _ in
                NewsFeedRouter().contentView
            }) {
                Text("News Feed")
            }
    }
}
