import Foundation
import XCTest
@testable import FlickrImageSearch

class MockQueue: Dispatching {
    func async(_ block: @escaping () -> Void) {
        block()
    }
}
