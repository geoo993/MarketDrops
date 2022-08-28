import Foundation
import SwiftUI
import MarketDropsRouting

final class NewsFeedRouter {}

extension NewsFeedRouter: Router {
    var contentView: AnyView {
        AnyView (
            Room(color: .orange) {
                Text("Room Four")
                    .foregroundColor(Color.white)
            }
        )
    }
}
