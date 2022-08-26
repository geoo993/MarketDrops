import SwiftUI

struct RoomFour: View {
    var body: some View {
        ZStack {
            Color.orange
            Text("Room Four")
                .foregroundColor(Color.white)
        }
    }
}

struct RoomFour_Previews: PreviewProvider {
    static var previews: some View {
        RoomFour()
    }
}
