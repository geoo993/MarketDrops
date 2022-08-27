import Foundation

public extension MarketDropsAPIClient {
    struct IPOCalandar: Decodable {
        public let companies : [Company]
        
        enum CodingKeys: String, CodingKey {
            case companies = "ipoCalendar"
        }
    }
}

public extension MarketDropsAPIClient.IPOCalandar {
    struct Company: Decodable {
        public var name: String
        public var symbol: String?
        public var date: String?
        public var exchange: String?
        public var status: String?
        public var price: String?
        public var numberOfShares: Int?
        public var totalSharesValue: Double?
    }
}
