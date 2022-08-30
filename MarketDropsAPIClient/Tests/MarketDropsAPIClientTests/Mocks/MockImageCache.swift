import Foundation
import UIKit
@testable import  MarketDropsAPIClient

final class MockImageCache: ImageCaching {
    private var storage: [URL: UIImage] = [:]
 
    func image(for url: URL) -> UIImage? {
        storage[url]
    }
    
    func insert(_ image: UIImage?, for url: URL) {
        storage[url] = image
    }
    
    func remove(for url: URL) {
        storage.removeValue(forKey: url)
    }
}
