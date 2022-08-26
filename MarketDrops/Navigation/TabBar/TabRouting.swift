import Foundation
import SwiftUI

struct TabRouting: Identifiable {
    var id = UUID()
    let item: TabItem
    let router: Router
}
