import SwiftUI
import MarketDropsRouting

final class FavouritesRouter {}

extension FavouritesRouter: Router {
    var contentView: AnyView {
        AnyView (
            RoomThree()
        )
    }
}
