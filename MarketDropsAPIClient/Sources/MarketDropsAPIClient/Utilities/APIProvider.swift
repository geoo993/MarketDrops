import Foundation

public enum APIProvider {
    case finnhub, marketaux, cityfalcon
}

extension APIProvider {
    var baseUrl: URL? {
        switch self {
        case .finnhub:
            return URL(string: "https://finnhub.io")!
        case .marketaux:
            return URL(string: "https://api.marketaux.com")!
        case .cityfalcon:
            return URL(string: "https://sandbox-api.cityfalcon.com")
        }
    }
    
    var apiToken: String {
        switch self {
        case .finnhub:
            return ""
        case .marketaux:
            return ""
        case .cityfalcon:
            return ""
        }
    }
}
