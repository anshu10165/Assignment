import Foundation
import UIKit
@testable import FlickrImageSearch

class MockAPIRequest: FlickrAPI {
    private let response: FlickrResponse?
    var fetchPhotosMethodCalled = false
    
    init(response: FlickrResponse? = nil) {
        self.response = response
    }

    func fetchPhotos(text: String,
                   pagenumber: Int,
                   handler: @escaping (Result<FlickrResponse?, ResponseError>) -> Void) {
        fetchPhotosMethodCalled = true
        response != nil ? handler(Result.success(response)) : handler(Result.failure(ResponseError.noResults))
        
    }
}
