import Foundation

protocol Dispatching: class {
    func async(_ block: @escaping () -> Void)
}

extension DispatchQueue: Dispatching {
    func async(_ block: @escaping () -> Void) {
        async(group: nil, execute: block)
    }
}
