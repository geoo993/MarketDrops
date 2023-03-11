import XCTest
import ComposableArchitecture
import MarketDropsDomainFixtures
@testable import MarketDrops

final class TabBarTests: XCTestCase {
    func test_didOpenUrlForIpoCalendarTab() throws {
        let url = try XCTUnwrap(URL(string: "applink:///ipo"))
        let store = makeSut(ipoCalendar: .init(newsfeed: .init()))
        store.send(.open(url))
        store.receive(.didSelectTab(.ipos))
        store.receive(.ipoCalendar(.onNavigate(.none)))
    }
    
    func test_didOpenUrlForFavouritesTab() throws {
        let url = try XCTUnwrap(URL(string: "applink:///favourites"))
        let store = makeSut(ipoCalendar: .init(newsfeed: .init()))
        store.send(.open(url))
        store.receive(.didSelectTab(.favourites)) {
            $0.selectedTab = .favourites
        }
    }
    
    func test_didFavouritesTab() {
        let store = makeSut(ipoCalendar: .init(newsfeed: .init()))
        store.send(.didSelectTab(.favourites)) {
            $0.selectedTab = .favourites
        }
    }
}

extension TabBarTests {
    private func makeSut(
        ipoCalendar: IPOs.State
    ) -> TestStore<
        TabBar.State,
        TabBar.Action,
        TabBar.State,
        TabBar.Action,
        ()
    > {
        .init(
            initialState: .init(
                ipoCalendar: ipoCalendar,
                favourites: .init(ipoCalendar: ipoCalendar)
            ),
            reducer: TabBar()
        )
    }
}
