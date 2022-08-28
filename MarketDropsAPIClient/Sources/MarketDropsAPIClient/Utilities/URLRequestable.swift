import Foundation
import Combine

public protocol URLRequestable {
    var session: HTTPSession { get }
    func execute<T: HTTPRequest, V: Decodable>(
        request: T
    ) -> AnyPublisher<V, T.ErrorObject>
    where T.ResponseObject == V, T.ErrorObject == MarketDropsAPIClient.Error
}
