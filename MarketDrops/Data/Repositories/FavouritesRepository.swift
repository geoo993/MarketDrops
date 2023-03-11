import Foundation
import MarketDropsDomain
import Dependencies

struct FavouritesRepository {
    var favouredList: () -> [String]
}

extension FavouritesRepository {
    static var live: Self = .init(
        favouredList: {
            UserPreferences.shared.allFavourites()
        }
    )
}

private enum FavouritesRepositoryKey: DependencyKey {
    static let liveValue = FavouritesRepository.live
}

extension DependencyValues {
    var favouritesRepository: FavouritesRepository {
        get { self[FavouritesRepositoryKey.self] }
        set { self[FavouritesRepositoryKey.self] = newValue }
    }
}
