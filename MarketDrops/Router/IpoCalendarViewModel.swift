import SwiftUI
import MarketDropsRouting

final class IpoCalendarViewModel: ObservableObject {
    @Published var route: RoutePath?
    
    func setNewsFeedNavigation(isActive: Bool) {
        self.route = isActive ? .ipoCalendar(.newsFeed("")) : nil
    }
    
    func navigate(to ipoRoutePath: IpoRoutePath?) {
        self.route = .ipoCalendar(ipoRoutePath)
    }
}
