import SwiftUI
import MarketDropsAPIClient
import ComposableArchitecture

struct ImageLoading: ReducerProtocol {
    struct State: Equatable {
        var image: Loading<UIImage> = .idle
    }

    enum Action: Equatable {
        case fetchImage(URL)
        case didLoad(Result<UIImage, AnyError>)
    }
    
    @Dependency(\.mainQueue) var queue
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .fetchImage(url):
                state.image = .loading(previous: nil)
                return DataController.shared.imageLoader.load(imageURL: url)
                    .receive(on: self.queue)
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
}
