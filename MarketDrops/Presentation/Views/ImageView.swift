import SwiftUI
import Combine
import MarketDropsAPIClient
import ComposableArchitecture

typealias ImageLoadingStore = Store<ImageLoading.State, ImageLoading.Action>
typealias ImageLoadingViewStore = ViewStore<ImageLoading.State, ImageLoading.Action>

enum ImageLoading {
    struct State: Equatable {
        var image: Loading<UIImage> = .idle
    }

    enum Action: Equatable {
        case fetchImage(URL)
        case didLoad(Result<UIImage, AnyError>)
    }

    struct Environment {
        let queue: AnySchedulerOf<DispatchQueue>
    }
    
    static let reducer: Reducer<State, Action, Environment> = .init { state, action, environment in
        switch action {
        case let .fetchImage(url):
            state.image = .loading(previous: nil)
            return DataController.shared.imageLoader.load(imageURL: url)
                .receive(on: environment.queue)
                .mapError(AnyError.init)
                .catchToEffect()
                .map(Action.didLoad)
                .eraseToEffect()
            
        case let .didLoad(result):
            state.image = Loading.from(result: result)
            return .none
        }
    }
}

struct ImageView: View {
    private let store: ImageLoadingStore
    private let imageUrl: URL

    init(store: ImageLoadingStore, imageUrl: URL) {
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

    @ViewBuilder private func idleView(_ viewStore: ImageLoadingViewStore) -> some View {
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
