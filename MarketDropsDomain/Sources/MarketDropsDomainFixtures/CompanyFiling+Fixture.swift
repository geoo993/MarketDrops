import Foundation
import MarketDropsDomain

extension CompanyFiling {
    public static func fixture(
        accessNumber: String = "0001493152-22-023814",
        symbol: String = "AAPL",
        cik: String = "1712762",
        form: String = "S1",
        date: Date = .init(),
        reportUrl: URL? = nil,
        filingUrl: URL? = nil
    ) -> Self {
        .init(
            accessNumber: accessNumber,
            symbol: symbol,
            cik: cik,
            form: form,
            date: date,
            reportUrl: reportUrl,
            filingUrl: filingUrl
        )
    }
}
