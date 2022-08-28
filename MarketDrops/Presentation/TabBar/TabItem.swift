import SwiftUI

enum TabItem: Hashable, CaseIterable {
    case ipos
    case favourites
}

extension TabItem {
    var title: String {
        switch self {
        case .ipos:
            return "IPO's"
        case .favourites:
            return "Favourites"
        }
    }
    
    var image: Image {
        switch self {
        case .ipos:
            return Image(systemName: "calendar.circle.fill")
        case .favourites:
            return Image(systemName: "heart.circle.fill")
        }
    }
}
