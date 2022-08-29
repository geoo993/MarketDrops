import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webview: WKWebView, context: Context) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
    }
   
    func makeCoordinator() -> Coordinator {
        return Coordinator(url: url)
    }
    
    final class Coordinator: NSObject {
        let url: URL
        init(url: URL) {
            self.url = url
        }
    }
}
