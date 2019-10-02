import Foundation
import UIKit

typealias ImageSearchViewModelProtocol = ViewModelActionable & ViewModelDisplayable

protocol ViewModelDisplayable {
    var imageCellViewModels: Int { get }
    func getImageCellViewModelForIndex(index: Int) -> ImageCellViewModelDisplayable?
}

protocol ViewModelActionable {
    var delegate: UpdateCollectionViewDelegate? { get set }
    func searchImagesForText(searchText: String?)
    func userDidDragAtPosition(offsetY: CGFloat, contentHeight: CGFloat, frameHeight: CGFloat)
}

protocol UpdateCollectionViewDelegate: class {
    func reloadImages(shouldScrollToTop: Bool)
    func updateTitleWith(message: String)
}

class ImageSearchViewModel: ImageSearchViewModelProtocol {
    
    private var totalPages: Int = 0
    private var pageNumber: Int = 0
    private let flickrAPI: FlickrAPI
    private let paginationActionable: PaginationActionable
    private var isFetchingMore = false
    private var imageCell: [ImageCellViewModelDisplayable] = []
    private var previousSearchText: String?
    private var shouldScrollToTop = false
    weak var delegate: UpdateCollectionViewDelegate?

    private var flickrResponse: FlickrResponse? {
        didSet {
            if let response = flickrResponse {
                self.totalPages = response.photos.pages
                for photo in response.photos.photo where !response.photos.photo.isEmpty {
                    let image = ImageCellViewModel(photo: photo)
                    imageCell.append(image)
                }
            }
        }
    }

    init(flickrAPI: FlickrAPI = FlickrPhotosRequest(),
         paginationActionable: PaginationActionable = PaginationProvider()) {
        self.flickrAPI = flickrAPI
        self.paginationActionable = paginationActionable
    }
    
    func searchImagesForText(searchText: String?) {
        if previousSearchText != searchText {
            previousSearchText = searchText
            imageCell.removeAll()
            shouldScrollToTop = true
            self.pageNumber = 0
            self.pageNumber = pageNumber + 1
            loadMore(pageNumber: pageNumber)
        } 
    }
    
    func userDidDragAtPosition(offsetY: CGFloat,
                               contentHeight: CGFloat,
                               frameHeight: CGFloat) {
        paginationActionable.userDidDragAtPosition(offsetY: offsetY,
                                                   contentHeight: contentHeight,
                                                   frameHeight: frameHeight)
        paginationActionable.paginationCallBack = { [weak self] in
            guard let strongSelf = self else { return }
            if !strongSelf.isFetchingMore {
                strongSelf.isFetchingMore = true
                strongSelf.shouldScrollToTop = false
                strongSelf.pageNumber = strongSelf.pageNumber + 1
                if strongSelf.pageNumber <= strongSelf.totalPages {
                    strongSelf.loadMore(pageNumber: strongSelf.pageNumber)
                }
            }
        }
    }
    
    private func loadMore(pageNumber: Int) {
        guard let text = self.previousSearchText else { return }
        flickrAPI.fetchPhotos(text: text, pagenumber: pageNumber) { result in
            switch result {
            case .success(let response):
                self.flickrResponse = response
                self.isFetchingMore = false
                if self.imageCell.isEmpty {
                    let text = NavigationTitle.noResults.rawValue
                    self.delegate?.updateTitleWith(message: text)
                } else {
                    let text = NavigationTitle.validResults.rawValue
                    self.delegate?.updateTitleWith(message: text)
                }
                self.delegate?.reloadImages(shouldScrollToTop: self.shouldScrollToTop)
            case .failure(let error):
                self.delegate?.updateTitleWith(message: error.reason)
            }
        }
    }
    
    var imageCellViewModels: Int {
        return imageCell.count
    }
    
    func getImageCellViewModelForIndex(index: Int) -> ImageCellViewModelDisplayable? {
        return index >= 0 ? imageCell[index] : nil
    }
}

private enum NavigationTitle: String {
    case noResults = "No Results"
    case validResults = "Image Search"
}
