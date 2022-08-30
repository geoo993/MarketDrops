import XCTest
import ComposableArchitecture
import MarketDropsDomain
import MarketDropsDomainFixtures
@testable import MarketDrops

@MainActor
final class FavouritesTests: XCTestCase {

    func test_filterFavourites() async {
        let companies: [IPOCalendar.Company] = [.fixture(symbol: "TSLA"), .fixture()]
        let store = makeSut(
            ipoCalendar: .init(newsfeed: .init()),
            dataProvider: .mock(list: ["TSLA"])
        )
        _ = await store.send(.fetchFavourites)
        _ = await store.send(.latest(.success(.fixture(companies: companies)))) {
            $0.loadedIpos = .loaded(.fixture(companies: companies))
        }
        _ = await store.send(.fetchFavourites) {
            $0.ipoCalendar.calendar = .loaded(.init(companies: [.fixture(symbol: "TSLA")]))
        }
    }

    func test_loadLatestIpoCalendar() async {
        let store = makeSut(ipoCalendar: .init(newsfeed: .init()))
        _ = await store.send(.latest(.success(.fixture()))) {
            $0.loadedIpos = .loaded(.fixture())
        }
    }
}

extension FavouritesTests {
    private func makeSut(
        ipoCalendar: IPOs.State,
        dataProvider: Favourites.DataProvider = .mock(),
        iposDataProvider: IPOs.DataProvider = .mock()
    ) -> TestStore<
        Favourites.State,
        Favourites.State,
        Favourites.Action,
        Favourites.Action,
        Favourites.Environment
    > {
        .init(
            initialState: .init(ipoCalendar: ipoCalendar),
            reducer: Favourites.reducer,
            environment: .init(
                dataProvider: dataProvider,
                iposDataProvider: iposDataProvider,
                queue: DispatchQueue.test.eraseToAnyScheduler()
            )
        )
    }
}

extension Favourites.DataProvider {
    static func mock(
        list: [String] = []
    ) -> Self {
        .init(favouredList: { list })
    }
}
