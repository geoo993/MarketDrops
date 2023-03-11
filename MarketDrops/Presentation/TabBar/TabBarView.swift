import SwiftUI
import ComposableArchitecture

struct TabBarView: View {
    @ObservedObject var viewStore: ViewStoreOf<TabBar>
    private let tabRoutings: [TabRouting]

    init(
        viewStore: ViewStoreOf<TabBar>,
        tabRoutings: [TabRouting]
    ) {
        self.viewStore = viewStore
        self.tabRoutings = tabRoutings
    }
    
    var body: some View {
        TabView(
            selection: viewStore.binding(get: \.selectedTab, send: TabBar.Action.didSelectTab)
        ) {
            ForEach(tabRoutings) { tab in
                NavigationView {
                    tab.router.contentView
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    tab.item.image
                    Text(tab.item.title)
                }.tag(tab.item)
            }
        }
    }
}
