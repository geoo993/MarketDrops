import Foundation
import MarketDropsDomain

extension IPOCalendar {
    public static func fixture() -> Self {
        .init(companies: [
            .fixture(),
            .fixture()
        ])
    }
}

extension IPOCalendar.Company {
    public static func fixture(
        name: String = "Apple",
        symbol: String = "AAPL",
        date: Date = .init(),
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
