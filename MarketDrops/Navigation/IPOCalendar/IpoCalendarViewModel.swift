import SwiftUI
import MarketDropsRouting

final class IpoCalendarViewModel: ObservableObject {
    @Published var route: IpoRoutePath?
    
    func setNewsFeedNavigation(isActive: Bool) {
        self.route = isActive ? .newsFeed("") : nil
    }
    
    func navigate(to ipoRoutePath: IpoRoutePath?) {
        self.route = ipoRoutePath
    }
}
