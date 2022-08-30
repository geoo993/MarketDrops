import Foundation
import MarketDropsDomain

public enum RoutePath: Equatable {
    case ipoCalendar(IpoRoutePath?)
    case favourites
    case unsupported
}

public enum IpoRoutePath: Equatable {
    case company(IPOCalendar.Company)
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
        guard
            let symbol = query["symbol"],
            let date = query["date"],
            let dateValue = DateFormatter.date().date(from: date),
            let status = query["status"]
        else {
            return .ipoCalendar(nil)
        }
        return .ipoCalendar(.company(
            .init(
                name: "",
                symbol: symbol,
                date: dateValue,
                status: .init(status, exchange: nil)
            )
        ))
    }
}
