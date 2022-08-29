import SwiftUI
import MarketDropsDomain
import MarketDropsCore

struct NewsFeedView: View {
    @State var viewStore: NewsFeedViewStore
    @ObservedObject var imageViewModel = ImageViewModel()
    @State var color: Color
    
    var body: some View {
        List {
            Unwrap(viewStore.filings.loaded) { value in
                Section {
                    ForEach(value) { filing in
                        CardFilingView(filing: filing)
                            .listRowSeparator(.hidden)
                            .listPadding(first: value.first, current: filing)
                    }
                    .listRowBackground(color)
                    .listRowInsets(.init())
                    
                } header: {
                    Text("newsfeed__filingsSectionTitle")
                }
                .headerProminence(.increased)
            }
            
            Unwrap(viewStore.news.loaded) { value in
                Section {
                    ForEach(value.articles) { article in
                        CardNewsView(imageViewModel: imageViewModel, article: article)
                            .listRowSeparator(.hidden)
                            .listPadding(first: value.articles.first, current: article)
                    }
                    .listRowBackground(color)
                    .listRowInsets(.init())
                } header: {
                    Text("newsfeed__newsSectionTitle")
                }
                .headerProminence(.increased)
            }
        }
        .listRowBackground(color)
    }
}
