import SwiftUI
import CasePaths
import MarketDropsRouting
import MarketDropsDomain
import ComposableArchitecture

final class IpoCalendarRouter {
    private let store: IPOsStore

    init(store: IPOsStore) {
        self.store = store
    }
}

extension IpoCalendarRouter: Router {
    var contentView: AnyView {
        AnyView (
            WithViewStore(self.store) { viewStore in
                Room(color: .white) {
                    VStack {
                        Unwrap(viewStore.calendar.loaded) { value in
                            List {
                                ForEach(value.companies) { company in
                                    CompanyNavigation(viewStore: viewStore, company: company)
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                        }
                    }
                }
                .alert(self.store.scope(state: \.alert), dismiss: .alertDismissed)
                .onAppear { viewStore.send(.fetchIpoCalendar) }
            }
            .navigationBarTitle("ipo_calendar__screen")
        )
    }
}

struct CompanyNavigation: View {
    @ObservedObject var viewStore: IPOsViewStore
    let company: IPOCalendar.Company

    var body: some View {
        NavigationLink(
            unwrap: viewStore.binding(get: \.route, send: IPOs.Action.onNavigate),
            case: /IpoRoutePath.company,
            onNavigate: { viewStore.send(.didSelectRoute($0, company)) },
            destination: { _ in
                NewsFeedRouter().contentView
            }) {
                CardView(item: company)
            }
    }
}
