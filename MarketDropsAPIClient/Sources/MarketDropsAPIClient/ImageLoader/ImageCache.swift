import Foundation
import UIKit

public protocol ImageCaching {
    func image(for url: URL) -> UIImage?
    func insert(_ image: UIImage?, for url: URL)
    func remove(for url: URL)
}

public final class ImageCache: ImageCaching {
    private var cache = NSCache<AnyObject, UIImage>()
    private let lock = NSLock()
    
    public init() {}
 
    public func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as AnyObject)
    }
    
    public func insert(_ image: UIImage?, for url: URL) {
        guard let image = image else {
            remove(for: url)
            return
        }
        lock.lock()
        cache.setObject(image, forKey: url as AnyObject)
        lock.unlock()
    }
    
    public func remove(for url: URL) {
        lock.lock()
        cache.removeObject(forKey: url as AnyObject)
        lock.unlock()
    }
}
