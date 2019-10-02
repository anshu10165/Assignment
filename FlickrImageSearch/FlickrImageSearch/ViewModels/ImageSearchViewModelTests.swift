import Foundation
import XCTest
@testable import FlickrImageSearch

class ImageSearchViewModelTests: XCTestCase {

    func testFetchPhotosAPICalledForValidText() {
        let mockRequest = MockAPIRequest()
        let viewModel = ImageSearchViewModel(flickrAPI: mockRequest)
        viewModel.searchImagesForText(searchText: "SomeText")
        XCTAssertTrue(mockRequest.fetchPhotosMethodCalled)
    }

    func testFetchPhotosAPINotCalledForNilText() {
        let mockRequest = MockAPIRequest()
        let viewModel = ImageSearchViewModel(flickrAPI: mockRequest)
        viewModel.searchImagesForText(searchText: nil)
        XCTAssertFalse(mockRequest.fetchPhotosMethodCalled)
    }

    func testPaginationMethodCalledOnScroll() {
        let mockProvider = MockPaginationProvider()
        let viewModel = ImageSearchViewModel(paginationActionable: mockProvider)
        viewModel.userDidDragAtPosition(offsetY: 1000.0,
                                        contentHeight: 24.0,
                                        frameHeight: 100.0)
        XCTAssertTrue(mockProvider.paginationMethodCalled)
    }
    
    func testPaginationClosureCalledForScroll() {
        let mockPagination = MockPaginationProvider()
        var paginationCallBackCalled = false
        mockPagination.paginationCallBack = {
            paginationCallBackCalled = true
        }
        let viewModel = ImageSearchViewModel(paginationActionable: mockPagination)
        viewModel.userDidDragAtPosition(offsetY: 1000.0,
                                        contentHeight: 24.0,
                                        frameHeight: 100.0)
        XCTAssertTrue(paginationCallBackCalled)
    }
    
    func testDelegateMethodCalledWhenResponseRecievedWithPhotos() {
        let mockDelegate = MockDelegate()
        let mockRequest = MockAPIRequest(response: mockFlickrResponse())
        let viewModel = ImageSearchViewModel(flickrAPI: mockRequest)
        viewModel.delegate = mockDelegate
        viewModel.searchImagesForText(searchText: "SomeText")
        XCTAssertNotNil(viewModel.delegate)
        XCTAssertTrue(mockDelegate.reloadImagesCalled)
    }
    
    func testDelegateUpdateTitleCalledWhenResponseRecievedWithNoPhotos() {
        let mockDelegate = MockDelegate()
        let photos = Photos(page: 3, total: "1212", photo: [], pages: 1)
        let response = FlickrResponse(photos: photos)
        let mockRequest = MockAPIRequest(response: response)
        let viewModel = ImageSearchViewModel(flickrAPI: mockRequest)
        viewModel.delegate = mockDelegate
        viewModel.searchImagesForText(searchText: "SomeText")
        XCTAssertTrue(mockDelegate.updateTitleCalled)
    }

    func testDelegateUpdateTitleCalledForNoResponseRecieved() {
        let mockDelegate = MockDelegate()
        let mockRequest = MockAPIRequest(response: nil)
        let viewModel = ImageSearchViewModel(flickrAPI: mockRequest)
        viewModel.delegate = mockDelegate
        viewModel.searchImagesForText(searchText: "RandomText")
        XCTAssertTrue(mockDelegate.updateTitleCalled)
    }
    
    func testCellViewModelNonNilForFlickrResponseAndValidIndex() {
        let mockDelegate = MockDelegate()
        let mockRequest = MockAPIRequest(response: mockFlickrResponse())
        let viewModel = ImageSearchViewModel(flickrAPI: mockRequest)
        viewModel.delegate = mockDelegate
        viewModel.searchImagesForText(searchText: "SomeText")
        XCTAssertTrue(viewModel.imageCellViewModels > 1)
        let cellViewModel = viewModel.getImageCellViewModelForIndex(index: 0)
        XCTAssertNotNil(cellViewModel)
    }

    func testCellViewModelNilForNegativeIndex() {
        let mockDelegate = MockDelegate()
        let mockRequest = MockAPIRequest(response: mockFlickrResponse())
        let viewModel = ImageSearchViewModel(flickrAPI: mockRequest)
        viewModel.delegate = mockDelegate
        viewModel.searchImagesForText(searchText: "SomeText")
        let cellViewModel = viewModel.getImageCellViewModelForIndex(index: -1)
        XCTAssertNil(cellViewModel)
    }
    
    private func mockFlickrResponse() -> FlickrResponse {
        let photoes1 = Photoes(id: "1", owner: "12341", secret: "some", server: "any", farm: 5)
        let photoes2 = Photoes(id: "2", owner: "1231", secret: "ome", server: "any", farm: 55)
        let photos = Photos(page: 3, total: "1212", photo: [photoes1, photoes2], pages: 1212)
        return FlickrResponse(photos: photos)
    }
}


private class MockDelegate: UpdateCollectionViewDelegate {
    var reloadImagesCalled = false
    var updateTitleCalled = false

    func reloadImages(shouldScrollToTop: Bool) {
        reloadImagesCalled = true
    }

    func updateTitleWith(message: String) {
        updateTitleCalled = true
    }
}


