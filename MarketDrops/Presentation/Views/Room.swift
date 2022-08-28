import SwiftUI

struct Room<Content: View>: View {
    private let color: Color
    private let content: () -> Content
    
    init(color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.color = color
        self.content = content
    }
    
    var body: some View {
        ZStack {
            color
            content()
        }
    }
}

struct RoomOne_Previews: PreviewProvider {
    static var previews: some View {
        Room(color: .red) {
            Text("Hello")
        }
    }
}
