import SwiftUI

struct RoomThree: View {
    var body: some View {
        ZStack {
            Color.green
            Text("Room Three")
                .foregroundColor(Color.white)
        }
    }
}

struct RoomThree_Previews: PreviewProvider {
    static var previews: some View {
        RoomThree()
    }
}
