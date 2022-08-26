import SwiftUI

final class IpoCalendarRouterViewModel: ObservableObject {
    @Published var route: RoutePath?
    
    func setNewsFeedNavigation(isActive: Bool) {
        self.route = isActive ? .newsFeed : nil
    }
}
