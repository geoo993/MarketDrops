import SwiftUI

struct OnActive<ForContent: View, ElseContent: View>: View {
    private let value: Bool
    private let forContent: () -> ForContent
    private let elseContent: () -> ElseContent

    init(
        for value: Bool,
        @ViewBuilder content: @escaping () -> ForContent,
        @ViewBuilder elseContent: @escaping () -> ElseContent
    ) {
        self.value = value
        self.forContent = content
        self.elseContent = elseContent
    }

    var body: some View {
        if value {
            forContent()
        } else {
            elseContent()
        }
    }
}
