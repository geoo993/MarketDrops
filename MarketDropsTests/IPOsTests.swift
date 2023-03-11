import XCTest
import ComposableArchitecture
import Combine
import MarketDropsDomain
import MarketDropsRouting
import MarketDropsDomainFixtures
@testable import MarketDrops

final class IPOsTests: XCTestCase {
    private var mainQueue: TestSchedulerOf<DispatchQueue>!
    
    override func setUp() {
        super.setUp()
        mainQueue = DispatchQueue.test
    }
    
    override func tearDown() {
        mainQueue = nil
        super.tearDown()
    }

    func test_fetchIpoCalendarFails() {
        let error = LocalisedError.apiError(.invalidUrl)
        let store = makeSut(
            repository: .mock(calendar: .failure(error))
        )
        store.send(.fetchIpoCalendar) {
            $0.alert = .none
            $0.calendar = .loading(previous: .none)
        }
        mainQueue.advance(by: 1)
        store.receive(.didLoad(.failure(.apiError(.invalidUrl)))) {
            $0.alert = .errorAlert(error.errorDescription ?? "")
            $0.calendar = .error(.init(error))
        }
        store.send(.alertDismissed) {
            $0.alert = .none
        }
    }
    
    func test_fetchIpoCalendarSucceeds() {
        let store = makeSut()
        store.send(.fetchIpoCalendar) {
            $0.alert = .none
            $0.calendar = .loading(previous: .none)
        }
        mainQueue.advance(by: 1)
        store.receive(.didLoad(.success(.fixture()))) {
            $0.calendar = .loaded(.fixture())
        }
    }
    
    func test_didSelectRoute() {
        let store = makeSut()
        store.send(.didSelectRoute(true, .fixture()))
        store.receive(.onNavigate(.company(.fixture()))) {
            $0.route = .company(.fixture())
            $0.newsfeed.company = .fixture()
        }
    }
}

extension IPOsTests {
    private func makeSut(
        newsfeed: NewsFeed.State = .init(),
        route: IpoRoutePath? = nil,
        repository: IPOsRepository = .mock()
    ) -> TestStore<
        IPOs.State,
        IPOs.Action,
        IPOs.State,
        IPOs.Action,
        ()
    > {
        .init(
            initialState: .init(newsfeed: newsfeed, route: route),
            reducer: IPOs()
        ) {
            $0.iposRepository = repository
            $0.mainQueue = mainQueue.eraseToAnyScheduler()
        }
    }
}

extension IPOsRepository {
    static func mock(
        calendar: Result<IPOCalendar, LocalisedError> = .success(.fixture())
    ) -> Self {
        .init(
            calendar: {
                Result.Publisher(calendar).eraseToAnyPublisher()
            }
        )
    }
}
