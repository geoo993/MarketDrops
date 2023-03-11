import XCTest
import ComposableArchitecture
import Combine
import MarketDropsDomain
import MarketDropsDomainFixtures
@testable import MarketDrops

final class NewsFeedTests: XCTestCase {
    private var mainQueue: TestSchedulerOf<DispatchQueue>!
    
    override func setUp() {
        super.setUp()
        mainQueue = DispatchQueue.test
    }
    
    override func tearDown() {
        mainQueue = nil
        super.tearDown()
    }

    func test_fetchFilingsFailsWithoutSymbol() {
        let store = makeSut(company: nil)
        store.send(.fetchFilings)
        store.receive(.didLoadFilings(.success([])))
    }
    
    func test_fetchFilingsFails() {
        let error = LocalisedError.apiError(.invalidUrl)
        let store = makeSut(
            repository: .mock(filings: .failure(error))
        )
        store.send(.fetchFilings) {
            $0.alert = .none
            $0.filings = .loading(previous: .none)
        }
        mainQueue.advance(by: 1)
        store.receive(.didLoadFilings(.failure(.apiError(.invalidUrl)))) {
            $0.alert = .errorAlert(error.errorDescription ?? "")
            $0.filings = .error(.init(error))
        }
        store.send(.alertDismissed) {
            $0.alert = .none
        }
    }
    
    func test_fetchFilingsSucceeds() {
        let store = makeSut()
        store.send(.fetchFilings) {
            $0.alert = .none
            $0.filings = .loading(previous: .none)
        }
        mainQueue.advance(by: 1)
        store.receive(.didLoadFilings(.success([.fixture()]))) {
            $0.filings = .loaded([.fixture()])
        }
    }

    func test_fetchNewsFails() {
        let error = LocalisedError.apiError(.invalidUrl)
        let store = makeSut(
            repository: .mock(news: .failure(error))
        )
        store.send(.fetchNews) {
            $0.alert = .none
            $0.news = .loading(previous: .none)
        }
        mainQueue.advance(by: 1)
        store.receive(.didLoadNews(.failure(.apiError(.invalidUrl)))) {
            $0.alert = .errorAlert(error.errorDescription ?? "")
            $0.news = .error(.init(error))
        }
        store.send(.alertDismissed) {
            $0.alert = .none
        }
    }
    
    func test_fetchNewsSucceeds() {
        let store = makeSut()
        store.send(.fetchNews) {
            $0.alert = .none
            $0.news = .loading(previous: .none)
        }
        mainQueue.advance(by: 1)
        store.receive(.didLoadNews(.success(.fixture()))) {
            $0.news = .loaded(.fixture())
        }
    }
    
    func test_didTapFavourite() {
        let store = makeSut()
        store.send(.didTapFavourite) {
            $0.isFavoured = true
        }
    }
}

extension NewsFeedTests {
    private func makeSut(
        company: IPOCalendar.Company? = .fixture(),
        isFavoured: Bool = false,
        repository: NewsFeedRepository = .mock()
    ) -> TestStore<
        NewsFeed.State,
        NewsFeed.Action,
        NewsFeed.State,
        NewsFeed.Action,
        ()
    > {
        .init(
            initialState: .init(company: company, isFavoured: isFavoured),
            reducer: NewsFeed()
        ) {
            $0.newsFeedRepository = repository
            $0.mainQueue = self.mainQueue.eraseToAnyScheduler()
        }
    }
}

extension NewsFeedRepository {
    static func mock(
        filings: Result<[CompanyFiling], LocalisedError> = .success([.fixture()]),
        news: Result<CompanyNews, LocalisedError> = .success(.fixture()),
        isFavoured: Bool = false
    ) -> Self {
        .init(
            filings: { _ in
                Result.Publisher(filings).eraseToAnyPublisher()
            },
            news: { _ in
                Result.Publisher(news).eraseToAnyPublisher()
            }, favoured: { symbol in
                isFavoured
            }, storeFavourite: { (symbol, isFavoured) in
                
            }
        )
    }
}
