import XCTest
import ComposableArchitecture
import Combine
import MarketDropsDomain
import MarketDropsAPIClient
import MarketDropsRouting
import MarketDropsDomainFixtures
@testable import MarketDrops

@MainActor
final class IPOsTests: XCTestCase {
    private let mainQueue = DispatchQueue.test

    func test_fetchIpoCalendarFails() async {
        let error = IPOs.Error.apiError(.invalidUrl)
        let store = makeSut(
            dataProvider: .mock(calendar: .failure(error))
        )
        _ = await store.send(.fetchIpoCalendar) {
            $0.alert = .none
            $0.calendar = .loading(previous: .none)
        }
        await mainQueue.advance(by: 1)
        await store.receive(.didLoad(.failure(.apiError(.invalidUrl)))) {
            $0.alert = .errorAlert(error.errorDescription ?? "")
            $0.calendar = .error(.init(error))
        }
        _ = await store.send(.alertDismissed) {
            $0.alert = .none
        }
    }
    
    func test_fetchIpoCalendarSucceeds() async {
        let store = makeSut()
        _ = await store.send(.fetchIpoCalendar) {
            $0.alert = .none
            $0.calendar = .loading(previous: .none)
        }
        await mainQueue.advance(by: 1)
        await store.receive(.didLoad(.success(.fixture()))) {
            $0.calendar = .loaded(.fixture())
        }
    }
    
    func test_didSelectRoute() async {
        let store = makeSut()
        _ = await store.send(.didSelectRoute(true, .fixture()))
        await store.receive(.onNavigate(.company(.fixture()))) {
            $0.route = .company(.fixture())
            $0.newsfeed.company = .fixture()
        }
    }
}

extension IPOsTests {
    private func makeSut(
        newsfeed: NewsFeed.State = .init(),
        route: IpoRoutePath? = nil,
        dataProvider: IPOs.DataProvider = .mock()
    ) -> TestStore<
        IPOs.State,
        IPOs.State,
        IPOs.Action,
        IPOs.Action,
        IPOs.Environment
    > {
        .init(
            initialState: .init(newsfeed: newsfeed, route: route),
            reducer: IPOs.reducer,
            environment: .init(
                dataProvider: dataProvider,
                queue: mainQueue.eraseToAnyScheduler()
            )
        )
    }
}

extension IPOs.DataProvider {
    static func mock(
        calendar: Result<IPOCalendar, IPOs.Error> = .success(.fixture())
    ) -> Self {
        .init(
            calendar: {
                Result.Publisher(calendar).eraseToAnyPublisher()
            }
        )
    }
}
