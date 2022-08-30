import XCTest
import ComposableArchitecture
import Combine
import MarketDropsDomain
import MarketDropsAPIClient
import MarketDropsDomainFixtures
@testable import MarketDrops

@MainActor
final class MarketDropsTests: XCTestCase {
    private let mainQueue = DispatchQueue.test

    func test_fetchFilingsFailsWithoutSymbol() async {
        let store = makeSut(company: nil)
        _ = await store.send(.fetchFilings)
        await store.receive(.didLoadFilings(.success([])))
    }
    
    func test_fetchFilingsFails() async {
        let error = NewsFeed.Error.apiError(.invalidUrl)
        let store = makeSut(
            dataProvider: .mock(filings: .failure(error))
        )
        _ = await store.send(.fetchFilings) {
            $0.alert = .none
            $0.filings = .loading(previous: .none)
        }
        await mainQueue.advance(by: 1)
        await store.receive(.didLoadFilings(.failure(.apiError(.invalidUrl)))) {
            $0.alert = .errorAlert(error.errorDescription ?? "")
            $0.filings = .error(.init(error))
        }
        _ = await store.send(.alertDismissed) {
            $0.alert = .none
        }
    }
    
    func test_fetchFilingsSucceeds() async {
        let store = makeSut()
        _ = await store.send(.fetchFilings) {
            $0.alert = .none
            $0.filings = .loading(previous: .none)
        }
        await mainQueue.advance(by: 1)
        await store.receive(.didLoadFilings(.success([.fixture()]))) {
            $0.filings = .loaded([.fixture()])
        }
    }

    func test_fetchNewsFails() async {
        let error = NewsFeed.Error.apiError(.invalidUrl)
        let store = makeSut(
            dataProvider: .mock(news: .failure(error))
        )
        _ = await store.send(.fetchNews) {
            $0.alert = .none
            $0.news = .loading(previous: .none)
        }
        await mainQueue.advance(by: 1)
        await store.receive(.didLoadNews(.failure(.apiError(.invalidUrl)))) {
            $0.alert = .errorAlert(error.errorDescription ?? "")
            $0.news = .error(.init(error))
        }
        _ = await store.send(.alertDismissed) {
            $0.alert = .none
        }
    }
    
    func test_fetchNewsSucceeds() async {
        let store = makeSut()
        _ = await store.send(.fetchNews) {
            $0.alert = .none
            $0.news = .loading(previous: .none)
        }
        await mainQueue.advance(by: 1)
        await store.receive(.didLoadNews(.success(.fixture()))) {
            $0.news = .loaded(.fixture())
        }
    }
    
    func test_didTapFavourite() async {
        let store = makeSut()
        _ = await store.send(.didTapFavourite) {
            $0.isFavoured = true
        }
    }
}

extension MarketDropsTests {
    private func makeSut(
        company: IPOCalendar.Company? = .fixture(),
        isFavoured: Bool = false,
        dataProvider: NewsFeed.DataProvider = .mock()
    ) -> TestStore<
        NewsFeed.State,
        NewsFeed.State,
        NewsFeed.Action,
        NewsFeed.Action,
        NewsFeed.Environment
    > {
        .init(
            initialState: .init(company: company, isFavoured: isFavoured),
            reducer: NewsFeed.reducer,
            environment: .init(
                dataProvider: dataProvider,
                queue: mainQueue.eraseToAnyScheduler()
            )
        )
    }
}

extension NewsFeed.DataProvider {
    static func mock(
        filings: Result<[CompanyFiling], NewsFeed.Error> = .success([.fixture()]),
        news: Result<CompanyNews, NewsFeed.Error> = .success(.fixture()),
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
