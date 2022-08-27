import Foundation
@testable import MarketDropsAPIClient

struct MockHTTPSessionDataTask: HTTPSessionDataTask {
    let request: URLRequest
    let session: MockHTTPSession
    let stub: MockHTTPSession.Stub?
    let completionHandler: (Data?, URLResponse?, Error?) -> Void
    
    public func resume() {
        var response: HTTPURLResponse?
        if let statusCode = stub?.statusCode, let url = request.url {
            response = HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion:  "HTTP/1.1",
                headerFields: nil
            )
        }
        completionHandler(stub?.data, response, nil)
    }
}
