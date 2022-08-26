import CasePaths
import SwiftUI

extension NavigationLink {
    init<Enum, Case, WrappedDestination>(
        unwrap optionalValue: Binding<Enum?>,
        case casePath: CasePath<Enum, Case>,
        onNavigate: @escaping (Bool) -> Void,
        @ViewBuilder destination: @escaping (Binding<Case>) -> WrappedDestination,
        @ViewBuilder label: @escaping () -> Label
    )
    where Destination == WrappedDestination?
    {
        let caseBinding = optionalValue.case(casePath)
        self.init(
            isActive: caseBinding.isPresent().didSet(onNavigate),
            destination: {
                if let value = Binding(unwrap: caseBinding) {
                    destination(value)
                }
            },
            label: label
        )
    }
}
