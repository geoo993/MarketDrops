import SwiftUI
import CasePaths
import MarketDropsRouting
import MarketDropsDomain
import ComposableArchitecture

final class IpoCalendarRouter {
    private let store: IPOsStore
    private let color = Color(UIColor.systemBackground)

    init(store: IPOsStore) {
        self.store = store
    }
}

extension IpoCalendarRouter: Router {
    var contentView: AnyView {
        AnyView (
            WithViewStore(self.store) { viewStore in
                Room(color: self.color) {
                    VStack {
                        Unwrap(viewStore.calendar.loaded) { value in
                            List {
                                ForEach(value.companies) { company in
                                    ZStack {
                                        CardView(item: company)
                                        CompanyNavigation(
                                            store: self.store,
                                            company: company
                                        )
                                    }
                                    .listRowBackground(self.color)
                                    .listRowInsets(
                                        EdgeInsets(
                                            top: UIConstants.padding,
                                            leading: UIConstants.padding,
                                            bottom: UIConstants.padding,
                                            trailing: UIConstants.padding
                                        )
                                    )
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                }
                .alert(self.store.scope(state: \.alert), dismiss: .alertDismissed)
                .navigationBarItems(trailing:
                    Button(action: {
                        // TODO: haptics
                        viewStore.send(.fetchIpoCalendar)
                    }) {
                        Image(systemName: "goforward")
                    }
                    .foregroundColor(.red)
                )
                .navigationBarTitle("ipo_calendar__screen")
            }
        )
    }
}

struct CompanyNavigation: View {
    let store: IPOsStore
    let company: IPOCalendar.Company

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationLink(
                unwrap: viewStore.binding(get: \.route, send: IPOs.Action.onNavigate),
                case: /IpoRoutePath.company,
                onNavigate: {
                    // TODO: haptics
                    viewStore.send(.didSelectRoute($0, company)) }
                ,
                destination: { _ in
                    NewsFeedRouter(
                        store: store.scope(
                            state: \.newsfeed,
                            action: IPOs.Action.newsfeed
                        )
                    ).contentView
                }
            ) {
                EmptyView()
            }
            .opacity(0.0)
            .buttonStyle(PlainButtonStyle())
        }
    }
}
