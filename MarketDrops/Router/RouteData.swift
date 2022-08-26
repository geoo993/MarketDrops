import Foundation

public struct RoutePathParameters<Value> {
    private let data: [String : Value]
    
    public init(_ data: [String : Value]) {
        self.data = data
    }
    
    public subscript(dynamicMember member: String) -> Value? {
        return data[member]
    }
}

public struct RouteData {
    public let path: RoutePath
    public let parameters: RoutePathParameters<String>
    
    public init(
        path: RoutePath,
        parameters: [String: String] = [:]
    ) {
        self.path = path
        self.parameters = RoutePathParameters(parameters)
    }
}

extension RouteData {
    init(deeplinkParser: DeeplinkParser) {
        let routePath: RoutePath = {
            switch deeplinkParser.pathComponents.first {
            case "ipo":
                return .ipoCalendar
            case "favourites":
                return .favourites
            case "profile":
                return .profile
            default:
                return .unsupported
            }
        }()
        self.init(path: routePath, parameters: deeplinkParser.queryItems)
    }
}
