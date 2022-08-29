import Foundation

public extension MarketDropsAPIClient {
    struct CompanyFiling: Decodable {
        public var accessNumber: String
        public var symbol: String
        public var cik: String
        public var form: String?
        public var date: Date
        public var reportUrl: String?
        public var filingUrl: String?
        
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
