import Foundation
import Combine
import MarketDropsAPIClient
import MarketDropsDomain

extension IPOs {
    enum Error: LocalizedError, Equatable {
        case apiError(MarketDropsAPIClient.Error)
        
        var errorDescription: String? {
            switch self {
            case let .apiError(error):
                return "error_alert_description".localized(arguments: error.localizedDescription)
            }
        }
    }
    
    struct DataProvider {
        var calendar: () -> AnyPublisher<IPOCalendar, Error>
    }
}

extension IPOs.DataProvider {
    static var live: Self = .init(
        calendar: {
            return DataController.shared.apiClient.execute(
                request: FetchIPOCalendarRequest(
                    fromDate: Date.days(by: -14),
                    toDate: Date.days(by: 21)
                )
            )
            .map(IPOCalendar.init)
            .mapError { IPOs.Error.apiError($0) }
            .eraseToAnyPublisher()
        }
    )
}
