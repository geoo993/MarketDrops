import Foundation
import MarketDropsAPIClient

final class DataController {
    static let shared = DataController()
    let apiClient = MarketDropsAPIClient()
    
    private init() {}
}
