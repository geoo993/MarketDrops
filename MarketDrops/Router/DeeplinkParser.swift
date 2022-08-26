import Foundation
import MarketDropsCore

struct DeeplinkParser {
    var pathComponents: ArraySlice<Substring>
    var queryItems: [String: String]
}

extension DeeplinkParser {
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
