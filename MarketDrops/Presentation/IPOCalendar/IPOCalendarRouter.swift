import SwiftUI
import CasePaths
import MarketDropsRouting
import MarketDropsDomain
import ComposableArchitecture

final class IpoCalendarRouter: ObservableObject {
    private let store: IPOsStore
    private var color = Color(UIColor.systemBackground)

    init(store: IPOsStore) {
        self.store = store
    }
}

extension IpoCalendarRouter: Router {
    var contentView: AnyView {
        AnyView (
            WithViewStore(self.store) { viewStore in
                Room(color: self.color) {
                    IPOCalendarView(
                        store: self.store,
                        viewStore: viewStore,
                        color: self.color
                    )
                }
                .alert(self.store.scope(state: \.alert), dismiss: .alertDismissed)
                .navigationBarItems(trailing:
                    Button(action: {
                        // TODO: haptics
                        viewStore.send(.fetchIpoCalendar)
                    }) {
                        Image(systemName: "goforward")
                    }
                    .foregroundColor(Color("brandPrimary"))
                )
                .navigationBarTitle("ipo_calendar__screen")
            }
        )
    }
}
