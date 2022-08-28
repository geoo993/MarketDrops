import Foundation
import Combine

public protocol HTTPSession {
    typealias HTTPResponse = URLSession.DataTaskPublisher.Output
    func dataTaskResponse(for request: URLRequest) -> AnyPublisher<HTTPResponse, URLError>
}

extension URLSession: HTTPSession {
    public func dataTaskResponse(for request: URLRequest) -> AnyPublisher<HTTPResponse, URLError> {
        dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
