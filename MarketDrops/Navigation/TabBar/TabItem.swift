import SwiftUI

enum TabItem: Hashable, CaseIterable {
    case ipos
    case favourites
    case profile
}

extension TabItem {
    var title: String {
        switch self {
        case .ipos:
            return "IPO's"
        case .favourites:
            return "Favourites"
        case .profile:
            return "Profile"
        }
    }
    
    var image: Image {
        switch self {
        case .ipos:
            return Image(systemName: "calendar.circle.fill")
        case .favourites:
            return Image(systemName: "heart.circle.fill")
        case .profile:
            return Image(systemName: "person.circle.fill")
        }
    }
}
