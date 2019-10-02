import Foundation
import XCTest
@testable import FlickrImageSearch

class ImageSearchControllerTests: XCTestCase {
    
    private let mockCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cellIdentifier")
        return collectionView
    }()
    
    func testSearchButtonTapFiresFetchImagesRequest() {
        let mockViewModel = MockViewModel()
        let controller = ImageSearchController(viewModel: mockViewModel)
        controller.viewDidLoad()
        controller.buttonTapped()
        XCTAssertTrue(mockViewModel.searchImagesCalled)
    }
    
    func testSearchImagesCalledFromCellForRowAtIndexPath() {
        let mockViewModel = MockViewModel()
        let controller = ImageSearchController(viewModel: mockViewModel)
        controller.viewDidLoad()
        let cell = controller.collectionView(mockCollectionView, cellForItemAt: IndexPath(item: 1, section: 0)) as? ImageCell
        XCTAssertNotNil(cell)
        XCTAssertTrue(mockViewModel.getImageCalled)
    }
    
    func testRequestNotCalledForEmptyTextInTextField() {
        let mockViewModel = MockViewModel()
        let controller = ImageSearchController(viewModel: mockViewModel)
        controller.viewDidLoad()
        let textField = UITextField()
        textField.text = ""
        let _ = controller.textFieldShouldReturn(textField)
        XCTAssertFalse(mockViewModel.searchImagesCalled)
    }
    
    func testRequestCalledForNotEmptyTextInTextField() {
        let mockViewModel = MockViewModel()
        let controller = ImageSearchController(viewModel: mockViewModel)
        controller.viewDidLoad()
        let textField = UITextField()
        textField.text = "some"
        let _ = controller.textFieldShouldReturn(textField)
        XCTAssertTrue(mockViewModel.searchImagesCalled)
    }
    
    func testShouldRangeInCharacterTextFieldDelegateMethodCalled() {
        let mockViewModel = MockViewModel()
        let controller = ImageSearchController(viewModel: mockViewModel)
        controller.viewDidLoad()
        let textField = UITextField()
        textField.text = "some"
        let delegateMethodCalled = controller.textField(textField, shouldChangeCharactersIn: NSRange(), replacementString: "")
       XCTAssertTrue(delegateMethodCalled)
    }
    
    func testPaginationMethodCalledOnScrollViewDidScroll() {
        let mockViewModel = MockViewModel()
        let controller = ImageSearchController(viewModel: mockViewModel)
        controller.viewDidLoad()
        let textField = UIScrollView()
        let _ = controller.scrollViewDidScroll(textField)
        XCTAssertTrue(mockViewModel.paginationMethodCalled)
    }
    
    func testNavigationTitle() {
        let mockViewModel = MockViewModel()
        let mockQueue = MockQueue()
        let controller = ImageSearchController(viewModel: mockViewModel, mainQueue: mockQueue)
        controller.viewDidLoad()
        let _ = controller.updateTitleWith(message: "some")
        XCTAssertEqual(controller.navigationItem.title, "some")
    }
    
    func testContentOffsetIsZeroForScrollToTopTrue() {
        let mockQueue = MockQueue()
        let mockViewModel = MockViewModel()
        let controller = ImageSearchController(viewModel: mockViewModel, mainQueue: mockQueue)
        controller.viewDidLoad()
        controller.reloadImages(shouldScrollToTop: true)
        XCTAssertEqual(mockCollectionView.contentOffset, .zero)
    }
    
    func testSizeOfCollectionViewItem() {
        let mockViewModel = MockViewModel()
        let controller = ImageSearchController(viewModel: mockViewModel)
        controller.viewDidLoad()
        let sizeForItemAtIndex = controller.collectionView(mockCollectionView, layout: UICollectionViewFlowLayout(), sizeForItemAt: IndexPath(item: 1, section: 0))
        let expectedSize = CGSize(width: ((mockCollectionView.frame.width / 3) - 8), height: (mockCollectionView.frame.width / 2.5))
        XCTAssertEqual(sizeForItemAtIndex, expectedSize)
    }
}

private class MockViewModel: ImageSearchViewModelProtocol {
    
    var delegate: UpdateCollectionViewDelegate?
    var searchImagesCalled = false
    var getImageCalled = false
    var paginationMethodCalled = false
    var imageCellViewModels: Int = 0
    
    func searchImagesForText(searchText: String?) {
        searchImagesCalled = true
    }
    
    func userDidDragAtPosition(offsetY: CGFloat, contentHeight: CGFloat, frameHeight: CGFloat) {
        paginationMethodCalled = true
    }
    
    func getImageCellViewModelForIndex(index: Int) -> ImageCellViewModelDisplayable? {
        getImageCalled = true
        return nil
    }
}

