import Foundation
import UIKit

final class ImageCache {
    private var cache = NSCache<AnyObject, UIImage>()
    private let lock = NSLock()
 
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as AnyObject)
    }
    
    func insert(_ image: UIImage?, for url: URL) {
        guard let image = image else {
            remove(for: url)
            return
        }
        lock.lock()
        cache.setObject(image, forKey: url as AnyObject)
        lock.unlock()
    }
    
    func remove(for url: URL) {
        lock.lock()
        cache.removeObject(forKey: url as AnyObject)
        lock.unlock()
    }
}
