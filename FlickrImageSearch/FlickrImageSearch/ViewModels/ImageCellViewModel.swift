import Foundation
import UIKit

protocol ImageCellViewModelDisplayable {
    var imageURLString: String { get }
}

class ImageCellViewModel: ImageCellViewModelDisplayable {
    
    private let photo: Photoes
    
    init(photo: Photoes) {
        self.photo = photo
    }
    
    var imageURLString: String {
        let farmId = photo.farm
        let server = photo.server
        let secret = photo.secret
        let id = photo.id
        return "https://farm\(farmId).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
}

