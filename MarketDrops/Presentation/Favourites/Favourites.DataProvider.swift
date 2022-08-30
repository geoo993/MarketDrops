import Foundation
import Combine
import MarketDropsAPIClient
import MarketDropsDomain

extension Favourites {
    struct DataProvider {
        var favouredList: () -> [String]
    }
}

extension Favourites.DataProvider {
    static var live: Self = .init(
        favouredList: {
            UserPreferences.shared.allFavourites()
        }
    )
}
