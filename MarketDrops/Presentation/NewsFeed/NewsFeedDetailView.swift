import SwiftUI

struct NewsFeedDetailView: View {
    @State var webPage: URL?
    @State var color: Color
    
    var body: some View {
        Room(color: color) {
            Unwrap(webPage) { url in
                WebView(url: url)
            }.frame(
                minWidth: 0,
                maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                minHeight: 0,
                maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                alignment: .topLeading
            )
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NewsFeedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedDetailView(
            webPage: URL(string: "www.apple.com")!,
            color: .red
        )
    }
}
