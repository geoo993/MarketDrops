import SwiftUI
import MarketDropsDomain
import MarketDropsAPIClient

extension IPOCalendar {
    init(model: MarketDropsAPIClient.IPOCalandar) {
        self.init(companies: model.companies.map(IPOCalendar.Company.init))
    }
}

extension IPOCalendar.Company {
    init(model: MarketDropsAPIClient.IPOCalandar.Company) {
        self.init(
            name: model.name,
            symbol: model.symbol,
            date: model.date,
            status: .init(model.status, exchange: model.exchange),
            price: model.price
        )
    }
    
    var primaryColor: Color {
        guard let value = status else { return Color.black }
        switch value {
        case .withdrawn: return Color("brandOrange")
        case .filed: return Color("brandBrown")
        case .expected: return Color("brandGreen")
        case .priced: return Color("brandPurple")
        }
    }
    
    var secondaryColor: Color {
        guard let value = status else { return Color.black }
        switch value {
        case .withdrawn: return Color("brandOrangeDarker")
        case .filed: return Color("brandBrownDarker")
        case .expected: return Color("brandGreenDarker")
        case .priced: return Color("brandPurpleDarker")
        }
    }
    
    var description: String? {
        guard let value = status else { return nil }
        let dateValue = date.formatted
        switch value {
        case .withdrawn:
            return "ipo_card__withdrawnOn".localized(arguments: dateValue)
        case .filed:
            return "ipo_card__filedOn".localized(arguments: dateValue)
        case let .expected(exchange):
            if let exchangeValue = exchange {
                return "ipo_card__expectedOnAndExchange".localized(arguments: dateValue, exchangeValue)
            } else {
                return "ipo_card__expectedOn".localized(arguments: dateValue)
            }
        case let .priced(exchange):
            if let exchangeValue = exchange {
                return "ipo_card__pricedOnAndExchange".localized(arguments: dateValue, exchangeValue)
            } else {
                return "ipo_card__pricedOn".localized(arguments: dateValue)
            }
        }
    }
}

extension CompanyFiling {
    init(model: MarketDropsAPIClient.CompanyFiling) {
        self.init(
            accessNumber: model.accessNumber,
            symbol: model.symbol,
            cik: model.cik,
            form: model.form,
            date: model.date,
            reportUrl: model.reportUrl.toUrl,
            filingUrl: model.filingUrl.toUrl
        )
    }
    
    var filingDescription: String {
        "newsfeed__filingsFootnote".localized(arguments: form ?? "", date.formatted)
    }
}

extension CompanyNews.Pagination {
    init(model: MarketDropsAPIClient.CompanyNews.Pagination) {
        self.init(
            found: model.found,
            returned: model.returned,
            limit: model.limit,
            page: model.page
        )
    }
}

extension CompanyNews.Article {
    init(model: MarketDropsAPIClient.CompanyNews.Article) {
        self.init(
            id: model.id,
            title: model.title,
            description: model.description,
            snippet: model.snippet,
            url: URL(string: model.url),
            image: URL(string: model.image),
            publishedAt: model.publishedAt,
            source: model.source
        )
    }
}

extension CompanyNews {
    init(model: MarketDropsAPIClient.CompanyNews) {
        self.init(
            pagination: Pagination(model: model.pagination),
            articles: model.articles.map(Article.init)
        )
    }
}
