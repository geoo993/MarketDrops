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

public extension RouteData {
    init?(deeplinkParser: DeeplinkParser) {
        guard let routePath = RoutePath(deeplinkParser: deeplinkParser) else {
            return nil
        }
        self.init(path: routePath, parameters: deeplinkParser.queryItems)
    }
}
