import SwiftUI

public extension LinearGradient {
    static func fill(_ colorA: Color, _ colorB: Color) -> LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [colorA, colorB, colorB, colorB]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
