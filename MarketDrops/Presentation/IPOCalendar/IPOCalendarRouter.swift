import SwiftUI
import CasePaths
import MarketDropsRouting
import MarketDropsDomain
import ComposableArchitecture

final class IpoCalendarRouter: ObservableObject {
    private let store: StoreOf<IPOs>
    private var color = Color(UIColor.systemBackground)

    init(store: StoreOf<IPOs>) {
        self.store = store
    }
}

extension IpoCalendarRouter: Router {
    var contentView: AnyView {
        AnyView (
            WithViewStore(self.store) { viewStore in
                NavigationStack {
                    Room(color: self.color) {
                        IPOCalendarView(
                            store: self.store,
                            color: self.color
                        )
                    }
                    .alert(self.store.scope(state: \.alert), dismiss: .alertDismissed)
                    .navigationBarItems(trailing:
                                            Button(action: {
                        HapticFeedback.tap.play()
                        viewStore.send(.fetchIpoCalendar)
                    }) {
                        Image(systemName: "goforward")
                    }
                        .foregroundColor(Color("brandPrimary"))
                    )
                    .navigationBarTitle("ipo_calendar__screen")
                }
            }
        )
    }
}
