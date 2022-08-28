import Foundation
import Combine
import MarketDropsCore

public final class MarketDropsAPIClient {
    public let session: HTTPSession
    private let networkMonitor: NetworkMonitoring

    public init(
        session: HTTPSession = URLSession.shared,
        networkMonitor: NetworkMonitoring = NetworkMonitor()
    ) {
        self.session = session
        self.networkMonitor = networkMonitor
    }
}

extension MarketDropsAPIClient: URLRequestable {
    public func execute<T: HTTPRequest, V: Decodable>(
        request: T
    ) -> AnyPublisher<V, T.ErrorObject>
    where T.ResponseObject == V, T.ErrorObject == Error {
        guard networkMonitor.isConnected else {
            return Fail(error: .noConnection).eraseToAnyPublisher()
        }
        do {
            let url = try self.request(from: request)
            return session.dataTaskResponse(for: url)
                .receive(on: request.queue)
                .mapError { .dataTaskFailed($0) }
                .flatMap(process)
                .eraseToAnyPublisher()
        } catch let error {
            return Fail(
                error: error as? MarketDropsAPIClient.Error ?? .failed(error.localizedDescription)
            ).eraseToAnyPublisher()
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
        _ result: URLSession.DataTaskPublisher.Output
    ) -> AnyPublisher<T, Error> {
        let responseValue = result.response as? HTTPURLResponse
        switch (result.data, responseValue) {
        case let (data, .some(response)) where HTTPCodes.success ~= response.statusCode:
            return decode(data: data)
        case let (_, .some(response)):
            return Fail(error: error(for: response.statusCode)).eraseToAnyPublisher()
        default:
            return Fail(error: .noResponse).eraseToAnyPublisher()
        }
    }
    
    private func decode<T: Decodable>(
        data: Data
    ) -> AnyPublisher<T, Error> {
        return Just(data)
            .decode(type: T.self, decoder:  JSONDecoder())
            .mapError { .decodingError($0.localizedDescription) }
            .eraseToAnyPublisher()
    }

    private func error(
        for code: HTTPCode
    ) -> MarketDropsAPIClient.Error {
        switch code {
        case HTTPCodes.authError: return .authenticationError
        case HTTPCodes.badResponse: return .badResponse(code)
        case HTTPCodes.outdated: return .outdatedRequest
        default: return .unknown
        }
    }
}
