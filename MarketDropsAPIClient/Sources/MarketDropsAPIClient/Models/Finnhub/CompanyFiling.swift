import Foundation

public extension MarketDropsAPIClient {
    struct CompanyFiling: Decodable {
        public let accessNumber: String
        public let symbol: String
        public let cik: String
        public let form: String?
        public let date: Date
        public let reportUrl: String?
        public let filingUrl: String?
        
        enum CodingKeys: String, CodingKey {
            case accessNumber
            case symbol
            case cik
            case form
            case date = "filedDate"
            case reportUrl
            case filingUrl
        }
    }
}
