import Foundation
import XCTest
@testable import FlickrImageSearch

class FlickrPhotosRequestTests: XCTestCase {
    
    func testFetchPhotosCompletionCalledForImagesRequest() {
        let session = MockURLSession()
        let request = FlickrPhotosRequest(urlSession: session)
        let data = Data(count: 16295)
        session.data = data
        request.fetchPhotos(text: "Las", pagenumber: 1) { _ in }
        XCTAssertTrue(session.isCompletionCalled)
    }
}

