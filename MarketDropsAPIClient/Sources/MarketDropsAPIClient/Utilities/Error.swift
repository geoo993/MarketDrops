import Foundation

public extension MarketDropsAPIClient {
    enum Error: Swift.Error, Equatable {
        case unknown
        case failed(String)
        case noConnection
        case dataTaskFailed(Swift.Error)
        case invalidUrl
        case invalidUrlComponent
        case encodingError(String)
        case noResponse
        case authenticationError
        case badResponse(HTTPCode)
        case outdatedRequest
        case decodingError(String)
    
        public var localizedDescription: String {
            switch self {
            case .unknown: return "Unknown"
            case .failed(let error): return "Failed with error: \(error)"
            case .noConnection: return "Please connect to the internet"
            case .authenticationError: return "You need to be authenticated"
            case .dataTaskFailed(let error): return "We encountered an issues during data task with error: \(error)"
            case .invalidUrl: return "We encounted an error using url"
            case .invalidUrlComponent: return "We encountered an error with url component"
            case .encodingError(let description): return "Encountered error when encoding url: \(description)"
            case .decodingError(let description): return "Failed to decode data: \(description)"
            case .outdatedRequest: return "The url you requested is outdated"
            case .noResponse: return "Did not get a HTTPURLResponse"
            case .badResponse(let statusCode): return "We had a bad network response with status code \(statusCode)"
            }
        }
    }
}

extension MarketDropsAPIClient.Error {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown),
            (.noConnection, .noConnection),
            (.authenticationError, .authenticationError),
            (.invalidUrl, .invalidUrl),
            (.invalidUrlComponent, .invalidUrlComponent),
            (.outdatedRequest, .outdatedRequest),
            (.noResponse, .noResponse):
            return true
        case (.failed(let left), .failed(let right)):
            return left == right
        case let (.dataTaskFailed(left), .dataTaskFailed(right)):
            return left.localizedDescription == right.localizedDescription
        case (.encodingError(let left), .encodingError(let right)):
            return left == right
        case (.decodingError(let left), .decodingError(let right)):
            return left == right
        case (.badResponse(let left), .badResponse(let right)):
            return left == right
        default:
            return false
        }
    }
}
