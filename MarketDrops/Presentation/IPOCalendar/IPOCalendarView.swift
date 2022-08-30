import SwiftUI
import MarketDropsDomain
import MarketDropsRouting
import ComposableArchitecture

struct IPOCalendarView: View {
    let store: IPOsStore
    @State var color: Color
    @State var emptyStateTitle: String?

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                OnActive(for: viewStore.companiesAvailable) {
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
                                .listRowSeparator(.hidden)
                                .listRowBackground(self.color)
                                .listRowInsets(
                                    EdgeInsets(
                                        top: UIConstants.spacing,
                                        leading: UIConstants.padding,
                                        bottom: UIConstants.spacing,
                                        trailing: UIConstants.padding
                                    )
                                )
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                } elseContent: {
                    Unwrap(emptyStateTitle) { value in
                        VStack(alignment: .center) {
                            Text(value)
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color("brandPrimary"))
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct CompanyNavigation: View {
    let store: IPOsStore
    @State var company: IPOCalendar.Company

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
