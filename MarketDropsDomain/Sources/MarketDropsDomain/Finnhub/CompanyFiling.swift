import Foundation

public struct CompanyFiling: Equatable, Identifiable {
    public var id: String { "\(symbol) \(accessNumber)" }
    public var accessNumber: String
    public var symbol: String
    public var cik: String
    public var form: String?
    public var date: Date
    public var reportUrl: URL?
    public var filingUrl: URL?
    
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
