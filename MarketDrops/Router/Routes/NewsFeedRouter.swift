import Foundation
import SwiftUI

final class NewsFeedRouter {}

extension NewsFeedRouter: Router {
    var contentView: AnyView {
        AnyView (
            RoomFour()
        )
    }
}
