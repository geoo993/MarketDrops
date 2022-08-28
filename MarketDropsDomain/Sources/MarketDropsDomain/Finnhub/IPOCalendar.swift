import Foundation

public struct IPOCalendar: Equatable {
    public let companies: [Company]

    public init(companies: [Company]) {
        self.companies = companies
    }
}

public extension IPOCalendar {
    struct Company: Equatable {
        public var name: String
        public var symbol: String?
        public var date: Date
        public var status: Status?
        public var price: String?
        
        public init(
            name: String,
            symbol: String? = nil,
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
    enum Status: Equatable {
        case withdrawn
        case filed
        case expected(exchange: String?)
        case priced(exchange: String?)
    }
}
