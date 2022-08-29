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
                    NewsFeedView(viewStore: viewStore, color: self.color)
                }
                .onAppear {
                    viewStore.send(.fetchFilings)
                    viewStore.send(.fetchNews)
                }
                .alert(self.store.scope(state: \.alert), dismiss: .alertDismissed)
                .navigationBarItems(trailing:
                    Button(action: {
                        // TODO: haptics
                        viewStore.send(.didTapFavourite)
                    }) {
                        Image(systemName: viewStore.favoured ? "heart.fill" : "heart")
                    }
                    .foregroundColor(Color("brandPrimary"))
                )
                .navigationBarTitle(viewStore.company?.name ?? viewStore.company?.symbol ?? "")
            }
        )
    }
}
