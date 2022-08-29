import SwiftUI
import MarketDropsRouting

final class FavouritesRouter {
    private let color = Color(UIColor.systemBackground)
}

extension FavouritesRouter: Router {
    var contentView: AnyView {
        AnyView (
            Room(color: color) {
                Text("Room Three")
                    .foregroundColor(Color.white)
            }
        )
    }
}
