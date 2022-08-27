import Foundation

public extension MarketDropsAPIClient {
    typealias HTTPCode = Int
    typealias HTTPCodes = Range<HTTPCode>
}

public extension MarketDropsAPIClient.HTTPCodes {
    static let success = 200 ..< 300
    static let authError = 401...500
    static let badResponse = 501..<600
    static let outdated = 600...
}
