import Foundation
import XCTest
@testable import FlickrImageSearch

class ImageDownloaderTests: XCTestCase {
    
    func testImageDownloaderCompletionCalledForImageDownloadMethod() {
        let session = MockURLSession()
        let data = Data(count: 53425)
        session.data = data
        let imageDownloader = ImageDownloader(urlSession: session)
        let urlString = "https://farm66.staticflickr.com/65535/48814544747_885bf9bd22.jpg"
        let url = URL(fileURLWithPath: urlString)
        imageDownloader.downloadImageforURL(url: url) { _ in }
        XCTAssertTrue(session.isCompletionCalled)
    }
}
