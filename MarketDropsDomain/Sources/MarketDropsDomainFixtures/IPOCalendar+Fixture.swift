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
        status: Status = .filed
    ) -> Self {
        .init(
            name: "Apple",
            symbol: "AAPL",
            date: .init(),
            status: status,
            price: "39.20"
        )
    }
}
