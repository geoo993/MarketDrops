import Foundation

public enum RoutePath: Equatable {
    case ipoCalendar(IpoRoutePath?)
    case favourites
    case unsupported
}

public enum IpoRoutePath: Equatable {
    case newsFeed(String)
}

extension RoutePath {
    init?(deeplinkParser: DeeplinkParser) {
        guard let firstComponent = deeplinkParser.pathComponents.first else {
            return nil
        }
        switch firstComponent {
        case "ipo":
            self = .ipoPath(deeplinkParser.queryItems)
        case "favourites":
            self = .favourites
        default:
            self = .unsupported
        }
    }
    
    static var ipoPath: ([String: String]) -> RoutePath = { query in
        guard let feed = query["feed"] else {
            return .ipoCalendar(nil)
        }
        return .ipoCalendar(.newsFeed(feed))
    }
}
