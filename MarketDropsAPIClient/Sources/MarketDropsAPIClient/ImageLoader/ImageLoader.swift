import UIKit
import Combine

public struct ImageLoader {
    private let session: HTTPSession
    private let queue: DispatchQueue
    private let imageCache = ImageCache()
    
    public init(
        session: HTTPSession = URLSession.shared,
        queue: DispatchQueue = .main
    ) {
        self.session = session
        self.queue = queue
    }
    
    public func load(imageURL: URL) -> AnyPublisher<UIImage, MarketDropsAPIClient.Error> {
        if let image = imageCache.image(for: imageURL) {
            return Just(image)
                .setFailureType(to: MarketDropsAPIClient.Error.self)
                .eraseToAnyPublisher()
        }
        let request = URLRequest(
            url: imageURL,
            cachePolicy: .returnCacheDataElseLoad,
            timeoutInterval: 60.0
        )
        return session.dataTaskResponse(for: request)
            .receive(on: queue)
            .map(\.data)
            .tryMap { data -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw MarketDropsAPIClient.Error.invalidUrl
                }
                imageCache.insert(image, for: imageURL)
                return image
            }
            .mapError { .dataTaskFailed($0) }
            .eraseToAnyPublisher()
    }
}
