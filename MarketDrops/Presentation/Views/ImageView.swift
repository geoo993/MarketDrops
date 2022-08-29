import SwiftUI
import Combine
import MarketDropsAPIClient

final class ImageViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    func loadImage(
        imageUrl: URL,
        completion: @escaping (Result<UIImage, AnyError>) -> Void
    ) {
        DataController.shared.imageLoader.load(imageURL: imageUrl)
            .mapError(AnyError.init)
            .sinkToResult(completion)
            .store(in: &cancellables)
    }
}


struct ImageView: View {
    private let viewModel: ImageViewModel
    private let imageURL: URL
    @State private var image: Loading<UIImage>
    
    init(viewModel: ImageViewModel, imageURL: URL, image: Loading<UIImage> = .idle) {
        self.viewModel = viewModel
        self.imageURL = imageURL
        self._image = .init(initialValue: image)
    }
    
    var body: some View {
        switch image {
        case .idle:
            idleView
        case .loading:
            loadingView
        case let .loaded(image):
            loadedView(image)
        case let .error(error):
            errorView(error)
        }
    }
}

private extension ImageView {
    func loadImage() {
        image = .loading(previous: nil)
        viewModel.loadImage(imageUrl: imageURL) { result in
            switch result {
            case let .success(value):
                image = .loaded(value)
            case let .failure(error):
                image = .error(AnyError(error))
            }
        }
    }
}

private extension ImageView {
    var idleView: some View {
        Text("").onAppear {
            self.loadImage()
        }
    }
    
    var loadingView: some View {
        ActivityIndicatorView(color: .gray, style: .medium)
    }
    
    func errorView(_ error: Error) -> some View {
        Text("image_loading__failed")
            .font(.footnote)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    func loadedView(_ uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
