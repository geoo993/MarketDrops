import Foundation
import MarketDropsDomain

extension IPOCalendar {
    public static func fixture(
        companies: [IPOCalendar.Company] = [.fixture(), .fixture()]
    ) -> Self {
        .init(companies: companies)
    }
}

extension IPOCalendar.Company {
    public static func fixture(
        name: String = "Apple",
        symbol: String = "AAPL",
        date: Date = Date(timeIntervalSince1970: 0),
        status: Status = .filed,
        price: String = "38.40"
    ) -> Self {
        .init(
            name: name,
            symbol: symbol,
            date: date,
            status: status,
            price: price
        )
    }
}
