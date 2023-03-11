import SwiftUI
import ComposableArchitecture

struct ImageView: View {
    private let store: StoreOf<ImageLoading>
    private let imageUrl: URL

    init(store: StoreOf<ImageLoading>, imageUrl: URL) {
        self.store = store
        self.imageUrl = imageUrl
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            switch viewStore.image {
            case .idle:
                idleView(viewStore)
            case .loading:
                loadingView
            case let .loaded(image):
                loadedView(image)
            case let .error(error):
                errorView(error)
            }
        }
    }

    @ViewBuilder private func idleView(_ viewStore: ViewStoreOf<ImageLoading>) -> some View {
        Text("").onAppear {
            viewStore.send(.fetchImage(imageUrl))
        }
    }
    
    private var loadingView: some View {
        ActivityIndicatorView(color: .white, style: .medium)
    }
    
    private func errorView(_ error: Error) -> some View {
        Text("image_loading__failed")
            .font(.footnote)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    private func loadedView(_ uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
