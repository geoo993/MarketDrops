import Foundation
import SwiftUI
import MarketDropsRouting

struct TabRouting: Identifiable {
    var id = UUID()
    let item: TabItem
    let router: Router
}
