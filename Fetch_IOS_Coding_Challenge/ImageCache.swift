import Foundation
import UIKit

// image cache
class ImageCache {
    // shared instance of ImageCache
    static let shared = ImageCache()

    // Cache to store images using NSString as the key and UIImage as the value
    private var cache = NSCache<NSString, UIImage>()
    
    // retrieve an image from the cache using a key
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    // store an image in the cache with a key
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
