import SwiftUI

struct RoomTwo: View {
    var body: some View {
        ZStack {
            Color.yellow
            Text("Room Two")
                .foregroundColor(Color.black)
        }
    }
}

struct RoomTwo_Previews: PreviewProvider {
    static var previews: some View {
        RoomTwo()
    }
}
