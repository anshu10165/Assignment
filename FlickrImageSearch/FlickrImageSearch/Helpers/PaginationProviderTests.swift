import Foundation
import XCTest
@testable import FlickrImageSearch

class PaginationProviderTests: XCTestCase {
    
    func testPaginationCallbackForFetchImagesRequest() {
        var requestForMoreImagesCalled = false
        let provider = PaginationProvider()
        provider.paginationCallBack = {
            requestForMoreImagesCalled = true
        }
        provider.userDidDragAtPosition(offsetY: 1000.0,
                                       contentHeight: 25.0,
                                       frameHeight: 34.0)
        XCTAssertTrue(requestForMoreImagesCalled)
    }
}
