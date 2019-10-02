import Foundation
import XCTest
@testable import FlickrImageSearch

class ImageCellViewModelTests: XCTestCase {
    
    func testImageUrlString() {
        let photo = Photoes(id: "12", owner: "1231", secret: "333", server: "1212", farm: 55)
        let viewModel = ImageCellViewModel(photo: photo)
        let expectedImageUrlString = "https://farm55.staticflickr.com/1212/12_333.jpg"
        XCTAssertEqual(viewModel.imageURLString, expectedImageUrlString)
    }
}
