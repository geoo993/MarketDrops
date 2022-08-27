import Foundation
import Combine
import MarketDropsCore

private typealias HTTPDataTaskResult = (data: Data?, response: HTTPURLResponse?, error: Error?)

public final class MarketDropsAPIClient {
    private let session: HTTPSession
    private let networkMonitor: NetworkMonitoring

    public init(
        session: HTTPSession = URLSession.shared,
        networkMonitor: NetworkMonitoring = NetworkMonitor()
    ) {
        self.session = session
        self.networkMonitor = networkMonitor
    }
}

extension MarketDropsAPIClient {
    public func execute<T, V: Decodable>(request: T) -> AnyPublisher<V, T.ErrorObject>
    where T: HTTPRequest, T.ResponseObject == V, T.ErrorObject == Error {
        Future { promise in
            self.execute(with: request, completion: promise)
        }.eraseToAnyPublisher()
    }
    
    func execute<T: HTTPRequest, V: Decodable>(
        with request: T,
        completion: @escaping (Result<V, T.ErrorObject>) -> Void
    ) where T: HTTPRequest, T.ResponseObject == V, T.ErrorObject == Error {
        guard networkMonitor.isConnected else {
            completion(.failure(.noConnection))
            return
        }
        do {
            let request = try self.request(from: request)
            let task = session.dataTask(with: request) {
                self.process(result: ($0, $1 as? HTTPURLResponse, $2), completion: completion)
            }
            task.resume()
        } catch let error {
            completion(
                .failure(error as? MarketDropsAPIClient.Error ?? .failed(error.localizedDescription))
            )
        }
    }

    private func request(from endPoint: any HTTPRequest) throws -> URLRequest {
        guard
            let url = endPoint.baseUrl,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            throw Error.invalidUrl
        }
        urlComponents.path = endPoint.path
        urlComponents.queryItems = endPoint.queryItems
        guard let url = urlComponents.url else { throw Error.invalidUrlComponent }
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.timeoutInterval = endPoint.timeoutInterval
        do {
            setHeaders(with: endPoint.headers, request: &request)
            try setBody(with: endPoint.body, request: &request)
            return request
        } catch {
            throw error
        }
    }

    private func setBody(with parameters: HTTPBody?, request: inout URLRequest) throws {
        do {
            guard let body = parameters else { return }
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            request.httpBody = jsonData
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw Error.encodingError(request.url?.absoluteString ?? "")
        }
    }

    private func setHeaders(with headers: HTTPHeaders?, request: inout URLRequest) {
        var values = ["Content-Type": "application/json"]
        if let httpHeaders = headers { values.merge(other: httpHeaders) }
        for (key, value) in values {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func process<T: Decodable>(
        result: HTTPDataTaskResult,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        if let error = result.error { completion(.failure(.dataTaskFailed(error))) }
        switch (result.data, result.response) {
        case let (.some(data), .some(response)) where HTTPCodes.success ~= response.statusCode:
            self.decode(data: data, completion: completion)
        case let (_, .some(response)):
            completion(.failure(self.handleResponse(with: response)))
        default:
            completion(.failure(.noResponse))
        }
    }
    
    private func decode<T: Decodable>(
        data: Data,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            completion(.success(model))
        } catch {
            completion(.failure(.decodingError(error.localizedDescription)))
        }
    }
    
    private func handleResponse(with response: HTTPURLResponse) -> MarketDropsAPIClient.Error {
        switch response.statusCode {
        case HTTPCodes.authError: return .authenticationError
        case HTTPCodes.badResponse: return .badResponse(response.statusCode)
        case HTTPCodes.outdated: return .outdatedRequest
        default: return .unknown
        }
    }
}
