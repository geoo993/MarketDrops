import SwiftUI
import MarketDropsRouting

final class TabBarViewModel: ObservableObject {
    @Published var selectedTab: TabItem
    @ObservedObject var ipoCalendarViewModel: IpoCalendarViewModel
    
    init(
        selectedTab: TabItem = .ipos,
        ipoCalendarViewModel: IpoCalendarViewModel = .init()
    ) {
        self.selectedTab = selectedTab
        self.ipoCalendarViewModel = ipoCalendarViewModel
    }
    
    func open(url: URL) {
        let routeData = RouteData(deeplinkParser: .init(url: url))
        switch routeData?.path {
        case let .ipoCalendar(path):
            selectedTab = .ipos
            ipoCalendarViewModel.navigate(to: path)
            
        case .favourites:
            selectedTab = .favourites

        case .unsupported, .none:
            break
        }
    }
}
