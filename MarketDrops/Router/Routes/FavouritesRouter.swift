import SwiftUI

final class FavouritesRouter {}

extension FavouritesRouter: Router {
    var contentView: AnyView {
        AnyView (
            RoomTwo()
        )
    }
}
