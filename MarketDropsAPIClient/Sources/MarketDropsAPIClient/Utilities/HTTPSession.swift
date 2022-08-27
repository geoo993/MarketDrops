import Foundation

public protocol HTTPSessionDataTask {
    func resume()
}

public protocol HTTPSession {
    func dataTask(
        with request: URLRequest,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> HTTPSessionDataTask
}

extension URLSession: HTTPSession {
    public func dataTask(
        with request: URLRequest,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> HTTPSessionDataTask {
        (dataTask(with: request, completionHandler: completion) as URLSessionDataTask) as HTTPSessionDataTask
    }
}

extension URLSessionDataTask: HTTPSessionDataTask {}

