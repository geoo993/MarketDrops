import XCTest
@testable import MarketDropsAPIClient

final class ImageLoaderTests: XCCombineTestCase {
    var session: MockHTTPSession!
    var imageCache: MockImageCache!
    var imageLoader: ImageLoader!
        
    override func setUp() {
        super.setUp()
        session = MockHTTPSession()
        imageCache = MockImageCache()
        imageLoader = ImageLoader(session: session, imageCache: imageCache)
    }

    override func tearDown() {
        session = nil
        imageCache = nil
        imageLoader = nil
        super.tearDown()
    }
    
    func test_loadImageAndCache() throws {
        let image = UIImage(systemName: "pencil")!
        let url = try XCTUnwrap(URL(string: "http://test.test"))
        let data = try XCTUnwrap(image.pngData())
        session.register(
            stub: MockHTTPSession.Stub(
                path: "",
                method: .get,
                statusCode: 201,
                data: data
            )
        )
        
        var output: UIImage?
        let expectation = XCTestExpectation(description: "Completion")
        imageLoader.load(imageURL: url)
            .sinkToResult { result in
                switch result {
                case let .success(value):
                    output = value
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                }
                expectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(output)
        XCTAssertNotNil(imageCache.image(for: url))
    }
    
    func test_imageLoadedFromCache() throws {
        let image = UIImage(systemName: "pencil")!
        let url = try XCTUnwrap(URL(string: "http://test.test"))
        imageCache.insert(image, for: url)

        var output: UIImage?
        let expectation = XCTestExpectation(description: "Completion")
        imageLoader.load(imageURL: url)
            .sinkToResult { result in
                switch result {
                case let .success(value):
                    output = value
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                }
                expectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(output)
        XCTAssertNotNil(imageCache.image(for: url))
        XCTAssertEqual(imageCache.image(for: url), image)
        XCTAssertEqual(output, image)
    }
    
    func test_invalidImageLoaded() throws {
        let url = try XCTUnwrap(URL(string: "http://test.test"))
        session.register(
            stub: MockHTTPSession.Stub(
                path: "",
                method: .get,
                statusCode: 201,
                data: Data()
            )
        )

        var output: MarketDropsAPIClient.Error?
        let expectation = XCTestExpectation(description: "Completion")
        imageLoader.load(imageURL: url)
            .sinkToResult { result in
                switch result {
                case .success:
                    XCTFail()
                case let .failure(error):
                    output = error
                }
                expectation.fulfill()
            }.store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(output)
        XCTAssertEqual(output, .dataTaskFailed(MarketDropsAPIClient.Error.invalidUrl))
    }
}
