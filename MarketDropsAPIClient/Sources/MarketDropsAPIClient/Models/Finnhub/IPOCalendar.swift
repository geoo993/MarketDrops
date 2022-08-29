import Foundation

public extension MarketDropsAPIClient {
    struct IPOCalandar: Decodable {
        public let companies: [Company]
        
        enum CodingKeys: String, CodingKey {
            case companies = "ipoCalendar"
        }
    }
}

public extension MarketDropsAPIClient.IPOCalandar {
    struct Company: Decodable {
        public let name: String
        public let symbol: String?
        public let date: Date
        public let exchange: String?
        public let status: String?
        public let price: String?
    }
}
