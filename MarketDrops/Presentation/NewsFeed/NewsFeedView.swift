import SwiftUI
import MarketDropsDomain
import MarketDropsCore

struct NewsFeedView: View {
    @State var viewStore: NewsFeedViewStore
    @State var color: Color
    
    var body: some View {
        List {
            Unwrap(viewStore.filings.loaded) { value in
                Section {
                    ForEach(value) { filing in
                        ZStack {
                            CardFilingView(filing: filing)
                            NavigationLink(
                                destination: NewsFeedDetailView(
                                    webPage: filing.reportUrl,
                                    color: color
                                )
                            ) {
                                EmptyView()
                            }
                            .opacity(0.0)
                            .buttonStyle(PlainButtonStyle())
                        }
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
                        ZStack {
                            CardNewsView(
                                store: .init(
                                    initialState: .init(),
                                    reducer: ImageLoading.reducer,
                                    environment: .init(queue: .main)
                                ),
                                article: article
                            )
                            NavigationLink(
                                destination: NewsFeedDetailView(
                                    webPage: article.url,
                                    color: color
                                )
                            ) {
                                EmptyView()
                            }
                            .opacity(0.0)
                            .buttonStyle(PlainButtonStyle())
                        }
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
