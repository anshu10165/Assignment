import Foundation
import UIKit
@testable import FlickrImageSearch

class MockURLSession: URLSession {
    var isCompletionCalled = false
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    var data: Data?
    var error: Error?
    
    override init() {}

    override func dataTask(with urlRequest: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let data = self.data
        let erro = self.error
        return URLSessionDataTaskMock {
            self.isCompletionCalled = true
            completionHandler(data, nil , erro)
        }
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}

extension MockURLSession: FlickrAPI {
    
    public func fetchPhotos(text: String, pagenumber: Int, handler: @escaping (Result<FlickrResponse?, ResponseError>) -> Void) {
        let url = URL(fileURLWithPath: "randomURL")
        let urlRequest = URLRequest(url: url)
        let task = dataTask(with: urlRequest) { _,_,_  in }
        task.resume()
    }
}

extension MockURLSession: ImageDownloadable {
    func downloadImageforURL(url: URL, handler: @escaping (UIImage?) -> Void) {
        let urlRequest = URLRequest(url: url)
        let task = dataTask(with: urlRequest) { _,_,_  in }
        task.resume()
    }
}
