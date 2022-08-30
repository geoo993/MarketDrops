import XCTest
import ComposableArchitecture
import MarketDropsDomainFixtures
@testable import MarketDrops

@MainActor
final class TabBarTests: XCTestCase {
    private let mainQueue = DispatchQueue.test

    func test_didOpenUrlForIpoCalendarTab() async throws {
        let url = try XCTUnwrap(URL(string: "applink:///ipo"))
        let store = makeSut(ipoCalendar: .init(newsfeed: .init()))
        _ = await store.send(.open(url))
        await store.receive(.didSelectTab(.ipos))
        await store.receive(.ipoCalendar(.onNavigate(.none)))
    }
    
    func test_didOpenUrlForFavouritesTab() async throws {
        let url = try XCTUnwrap(URL(string: "applink:///favourites"))
        let store = makeSut(ipoCalendar: .init(newsfeed: .init()))
        _ = await store.send(.open(url))
        await store.receive(.didSelectTab(.favourites)) {
            $0.selectedTab = .favourites
        }
    }
    
    func test_didFavouritesTab() async {
        let store = makeSut(ipoCalendar: .init(newsfeed: .init()))
        _ = await store.send(.didSelectTab(.favourites)) {
            $0.selectedTab = .favourites
        }
    }
}

extension TabBarTests {
    private func makeSut(
        ipoCalendar: IPOs.State,
        iposDataProvider: IPOs.DataProvider = .mock()
    ) -> TestStore<
        TabBar.State,
        TabBar.State,
        TabBar.Action,
        TabBar.Action,
        TabBar.Environment
    > {
        .init(
            initialState: .init(
                ipoCalendar: ipoCalendar,
                favourites: .init(ipoCalendar: ipoCalendar)
            ),
            reducer: TabBar.reducer,
            environment: .init(
                iposDataProvider: iposDataProvider,
                queue: mainQueue.eraseToAnyScheduler()
            )
        )
    }
}
