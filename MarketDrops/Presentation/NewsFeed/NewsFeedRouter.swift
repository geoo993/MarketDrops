import SwiftUI
import MarketDropsRouting
import ComposableArchitecture

final class NewsFeedRouter {
    private let store: StoreOf<NewsFeed>
    private let color = Color(UIColor.systemBackground)

    init(store: StoreOf<NewsFeed>) {
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
                        HapticFeedback.tap.play()
                        viewStore.send(.didTapFavourite)
                    }) {
                        Image(systemName: viewStore.isFavoured ? "heart.fill" : "heart")
                    }
                    .foregroundColor(Color("brandPrimary"))
                )
                .navigationBarTitle(viewStore.company?.name ?? viewStore.company?.symbol ?? "")
            }
        )
    }
}
