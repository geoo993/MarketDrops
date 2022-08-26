import SwiftUI

final class TabBarViewModel: ObservableObject {
    @Published var selectedTab: TabItem
    
    init(selectedTab: TabItem = .ipos) {
        self.selectedTab = selectedTab
    }
    
    func open(url: URL) {
        let routeData = RouteData(deeplinkParser: .init(url: url))
        switch routeData.path {
        case .ipoCalendar:
            selectedTab = .ipos
        case .favourites:
            selectedTab = .favourites
        case .profile:
            selectedTab = .profile
        default: break
        }
    }
}
