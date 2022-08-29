import Foundation
import SwiftUI
import MarketDropsRouting
import MarketDropsDomain
import ComposableArchitecture

final class NewsFeedRouter {
    private let store: NewsFeedStore
    private let color = Color(UIColor.systemBackground)

    init(store: NewsFeedStore) {
        self.store = store
    }
}

extension NewsFeedRouter: Router {
    var contentView: AnyView {
        AnyView (
            WithViewStore(self.store) { viewStore in
                Room(color: self.color) {
                    List {
                        Unwrap(viewStore.filings.loaded) { value in
                            Section {
                                ForEach(value) { filing in
                                    Text(filing.symbol)
                                }
                            } header: {
                                Text("newsfeed__filingsSectionTitle")
                            }
                            .headerProminence(.increased)
                        }
                        
                        Section {
                            Text("Item 2")
                            Text("Item 3")
                            Text("Item 4")
                        }
                        Section {
                            Text("Item 5")
                            Text("Item 6")
                            Text("Item 7")
                        }
                    }
                    .listRowBackground(self.color)
                }
                .onAppear {
                    viewStore.send(.fetchFilings)
                }
                .alert(self.store.scope(state: \.alert), dismiss: .alertDismissed)
                .navigationBarItems(trailing:
                    Button(action: {
                        // TODO: haptics
                        viewStore.send(.didTapFavourite)
                    }) {
                        Image(systemName: viewStore.favoured ? "heart.fill" : "heart")
                    }
                    .foregroundColor(.red)
                )
                .navigationBarTitle(viewStore.company?.name ?? viewStore.company?.symbol ?? "")
            }
        )
    }
}
