import SwiftUI

struct CardStyle: ViewModifier {
    var primaryColor: Color
    let secondaryColor: Color
    var radius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(LinearGradient.fill(primaryColor, secondaryColor))
            .cornerRadius(radius)
            .overlay(
                RoundedRectangle(cornerRadius: radius).stroke(primaryColor, lineWidth: 1)
            )
    }
}

extension View {
    func cardStyle(primaryColor: Color, secondaryColor: Color, radius: CGFloat) -> some View {
        ModifiedContent(
            content: self,
            modifier: CardStyle(primaryColor: primaryColor, secondaryColor: secondaryColor, radius: radius)
        )
    }
}
