import Foundation
import UIKit

protocol ImageDownloadable {
    func downloadImageforURL(url: URL, handler: @escaping (_ image: UIImage?) -> Void)
}

class ImageDownloader: ImageDownloadable {
    
    private let imageCache:NSCache<NSString, UIImage>
    private let urlSession: URLSession
    private let mainQueue: Dispatching
    
    init(urlSession: URLSession = URLSession.shared,
         imageCache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>(),
         mainQueue: Dispatching = DispatchQueue.main) {
        self.urlSession = urlSession
        self.imageCache = imageCache
        self.mainQueue = mainQueue
    }
    
    func downloadImageforURL(url: URL, handler: @escaping (_ image: UIImage?) -> Void) {
        let urlRequest = URLRequest(url: url)
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            handler(cachedImage)
        } else {
            urlSession.dataTask(with: urlRequest) { (data, response, error) in
                guard let dataResponse = data, error == nil else {
                    return
                }
                if let image = UIImage(data: dataResponse) {
                 self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    self.mainQueue.async {
                        handler(image)
                    }
                }
            }.resume()
        }
    }
}
