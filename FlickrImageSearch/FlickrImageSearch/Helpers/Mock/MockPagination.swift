import Foundation
import XCTest
@testable import FlickrImageSearch

class MockPaginationProvider: PaginationActionable {
    
    var paginationMethodCalled = false
    var paginationCallBack: (() -> Void)?
    
    func userDidDragAtPosition(offsetY: CGFloat, contentHeight: CGFloat, frameHeight: CGFloat) {
        paginationMethodCalled = true
        paginationCallBack?()
    }
}
