import SwiftUI

struct RoomOne<Content: View>: View {
    private let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Color.red
            content()
        }
    }
}

struct RoomOne_Previews: PreviewProvider {
    static var previews: some View {
        RoomOne {
            Text("Hello")
        }
    }
}
