import Foundation
import MarketDropsCore

public struct IPOCalendar: Equatable {
    public let companies: [Company]

    public init(companies: [Company]) {
        self.companies = companies
    }
}

public extension IPOCalendar {
    struct Company: Hashable, Identifiable {
        public let name: String
        public let symbol: String
        public let date: Date
        public let status: Status?
        public let price: String?
        
        public init(
            name: String,
            symbol: String,
            date: Date,
            status: Status?,
            price: String? = nil
        ) {
            self.name = name
            self.symbol = symbol
            self.date = date
            self.status = status
            self.price = price
        }
    }
}
    
public extension IPOCalendar.Company {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String {
        "\(symbol)-\(DateFormatter.date().string(from: date))"
    }
    
    enum Status: Equatable {
        case withdrawn
        case filed
        case expected(exchange: String?)
        case priced(exchange: String?)
        
        public init?(_ model: String?, exchange: String?) {
            guard let value = model else { return nil }
            switch value {
            case "withdrawn": self = .withdrawn
            case "filed": self = .filed
            case "expected": self = .expected(exchange: exchange)
            case "priced": self = .priced(exchange: exchange)
            default: return nil
            }
        }
    }
}
