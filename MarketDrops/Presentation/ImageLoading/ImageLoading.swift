import SwiftUI
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
