import SwiftUI

final class ProfileRouter {}

extension ProfileRouter: Router {
    var contentView: AnyView {
        AnyView (
            RoomThree()
        )
    }
}
