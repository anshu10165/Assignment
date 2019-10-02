import Foundation
import UIKit

protocol PaginationActionable: class {
    var paginationCallBack: (()-> Void)? { get set }
    func userDidDragAtPosition(offsetY: CGFloat,
                               contentHeight: CGFloat,
                               frameHeight: CGFloat)
}

class PaginationProvider: PaginationActionable {
    var paginationCallBack: (() -> Void)?
    func userDidDragAtPosition(offsetY: CGFloat, contentHeight: CGFloat, frameHeight: CGFloat) {
        if offsetY > contentHeight - frameHeight * 5 {
            paginationCallBack?()
        }
    }
}
