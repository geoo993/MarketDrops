import Foundation
import MarketDropsCore

public struct DeeplinkParser {
    public var pathComponents: ArraySlice<Substring>
    public var queryItems: [String: String]
}

public extension DeeplinkParser {
    init(url: URL) {
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = urlComponents?.queryItems ?? []
            .filter { $0.value.isNilOrEmpty }
        let items: [String: String] = queryItems.reduce(into: [:]) { (dictionary, queryItem) in
            dictionary[queryItem.name] = queryItem.value ?? ""
        }
        self.init(
            pathComponents: url.path.split(separator: "/")[...],
            queryItems: items
        )
    }
}
