import Foundation

public struct CompanyFiling: Equatable, Identifiable {
    public var id: String { "\(symbol) \(accessNumber)" }
    public let accessNumber: String
    public let symbol: String
    public let cik: String
    public let form: String?
    public let date: Date
    public let reportUrl: URL?
    public let filingUrl: URL?
    
    public init(
        accessNumber: String,
        symbol: String,
        cik: String,
        form: String? = nil,
        date: Date,
        reportUrl: URL? = nil,
        filingUrl: URL? = nil
    ) {
        self.accessNumber = accessNumber
        self.symbol = symbol
        self.cik = cik
        self.form = form
        self.date = date
        self.reportUrl = reportUrl
        self.filingUrl = filingUrl
    }
}
