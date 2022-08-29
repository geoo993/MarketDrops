import SwiftUI

struct ListPadding<T: Identifiable>: ViewModifier {
    let first: T?
    let current: T

    func body(content: Content) -> some View {
        if current.id == first?.id {
            return content.padding(EdgeInsets())
        } else {
            return content
                .padding(
                    EdgeInsets(
                        top: UIConstants.spacing,
                        leading: 0,
                        bottom: 0,
                        trailing: 0
                    )
                )
        }
    }
}

extension View {
    func listPadding<T: Identifiable>(first: T?, current: T) -> some View {
        self.modifier(ListPadding(first: first, current: current))
    }
}
