import Foundation

public typealias HTTPHeaders = [String: String]
public typealias HTTPBody = [String: Any]

public protocol HTTPRequest {
    associatedtype ResponseObject = Any
    associatedtype ErrorObject = Error
    var provider: APIProvider { get }
    var baseUrl: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: HTTPBody? { get set }
    var timeoutInterval: TimeInterval { get }
    var queue: DispatchQueue { get set }
}

public extension HTTPRequest {
    var baseUrl: URL? { provider.baseUrl }
    var method: HTTPMethod { .get }
    var headers: HTTPHeaders? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var timeoutInterval: TimeInterval { 30.0 }
}
