import Foundation
import MarketDropsAPIClient

enum LocalisedError: LocalizedError, Equatable {
    case apiError(MarketDropsAPIClient.Error)
    
    var errorDescription: String? {
        switch self {
        case let .apiError(error):
            return "error_alert_description".localized(arguments: error.localizedDescription)
        }
    }
}
