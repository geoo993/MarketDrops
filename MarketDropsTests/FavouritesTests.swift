import XCTest
import ComposableArchitecture
import MarketDropsDomain
import MarketDropsDomainFixtures
@testable import MarketDrops

final class FavouritesTests: XCTestCase {
    func test_filterFavourites() {
        let companies: [IPOCalendar.Company] = [.fixture(symbol: "TSLA"), .fixture()]
        let store = makeSut(
            ipoCalendar: .init(newsfeed: .init()),
            repository: .mock(list: ["TSLA"])
        )
        store.send(.fetchFavourites)
        store.send(.latest(.success(.fixture(companies: companies)))) {
            $0.loadedIpos = .loaded(.fixture(companies: companies))
        }
        store.send(.fetchFavourites) {
            $0.ipoCalendar.calendar = .loaded(.init(companies: [.fixture(symbol: "TSLA")]))
        }
    }

    func test_loadLatestIpoCalendar() {
        let store = makeSut(ipoCalendar: .init(newsfeed: .init()))
        store.send(.latest(.success(.fixture()))) {
            $0.loadedIpos = .loaded(.fixture())
        }
    }
}

extension FavouritesTests {
    private func makeSut(
        ipoCalendar: IPOs.State,
        repository: FavouritesRepository = .mock()
    ) -> TestStore<
        Favourites.State,
        Favourites.Action,
        Favourites.State,
        Favourites.Action,
        ()
    > {
        .init(
            initialState: .init(ipoCalendar: ipoCalendar),
            reducer: Favourites()
        ) {
            $0.favouritesRepository = repository
        }
    }
}

extension FavouritesRepository {
    static func mock(
        list: [String] = []
    ) -> Self {
        .init(favouredList: { list })
    }
}
