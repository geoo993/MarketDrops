import Foundation
import Combine
import MarketDropsAPIClient
import MarketDropsDomain
import Dependencies

struct IPOsRepository {
    var calendar: () -> AnyPublisher<IPOCalendar, LocalisedError>
}

extension IPOsRepository {
    static var live: Self = .init(
        calendar: {
            DataController.shared.apiClient.execute(
                request: FetchIPOCalendarRequest(
                    fromDate: Date.days(by: -14),
                    toDate: Date.days(by: 21)
                )
            )
            .map(IPOCalendar.init)
            .mapError { LocalisedError.apiError($0) }
            .eraseToAnyPublisher()
        }
    )
}

private enum IPOsRepositoryKey: DependencyKey {
    static let liveValue = IPOsRepository.live
}

extension DependencyValues {
    var iposRepository: IPOsRepository {
        get { self[IPOsRepositoryKey.self] }
        set { self[IPOsRepositoryKey.self] = newValue }
    }
}
