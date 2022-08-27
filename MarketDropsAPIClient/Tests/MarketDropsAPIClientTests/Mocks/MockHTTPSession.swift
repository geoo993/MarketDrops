import Foundation
@testable import  MarketDropsAPIClient

final class MockHTTPSession: HTTPSession {
    private var stub: Stub?
    
    func register(stub: Stub) {
        self.stub = stub
    }

    func dataTask(
        with request: URLRequest,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> HTTPSessionDataTask {
        let stub = self.registeredStub(for: request)
        return MockHTTPSessionDataTask(
            request: request,
            session: self,
            stub: stub,
            completionHandler: completion)
    }
    
    private func registeredStub(for request: URLRequest) -> Stub? {
        guard
            let stub = self.stub,
            let path = request.url?.path,
            request.httpMethod == stub.method.rawValue,
            path == stub.path
        else { return nil }
        return stub
    }
}
    

extension MockHTTPSession {
    struct Stub {
        let path: String
        let method: HTTPMethod
        let statusCode: MarketDropsAPIClient.HTTPCode
        let data: Data

        public init(
            path: String,
            method: HTTPMethod,
            statusCode: MarketDropsAPIClient.HTTPCode,
            data: Data = Data()
        ) {
            self.path = path
            self.method = method
            self.statusCode = statusCode
            self.data = data
        }
    }
}
