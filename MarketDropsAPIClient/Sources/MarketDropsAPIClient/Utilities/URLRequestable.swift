import Foundation

public protocol URLRequestable {
    var session: HTTPSession { get }
    func execute<T: HTTPRequest, V: Decodable>(
        with request: T,
        completion: @escaping (Result<V, T.ErrorObject>) -> Void
    ) where T: HTTPRequest, T.ResponseObject == V, T.ErrorObject == MarketDropsAPIClient.Error
}
