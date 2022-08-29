import UIKit
import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    let color: UIColor
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.color = color
        return indicator
    }

    func updateUIView(
        _ uiView: UIActivityIndicatorView,
        context: Context
    ) {
        uiView.startAnimating()
    }
}
