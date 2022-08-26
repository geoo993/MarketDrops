import SwiftUI

struct TabBarView: View {
    @ObservedObject var viewModel: TabBarViewModel
    private let tabRoutings: [TabRouting]
    
    init(viewModel: TabBarViewModel, tabRoutings: [TabRouting]) {
        self.viewModel = viewModel
        self.tabRoutings = tabRoutings
        setupUI()
    }
    
    private func setupUI() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.primary)
        UITabBar.appearance().barTintColor = UIColor(Color.green)
    }
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
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
