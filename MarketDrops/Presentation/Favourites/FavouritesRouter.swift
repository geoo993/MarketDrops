import SwiftUI
import MarketDropsRouting

final class FavouritesRouter {}

extension FavouritesRouter: Router {
    var contentView: AnyView {
        AnyView (
            Room(color: .green) {
                Text("Room Three")
                    .foregroundColor(Color.white)
            }
        )
    }
}
