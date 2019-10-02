import Foundation

enum Result<T, U: Error> {
  case success(T)
  case failure(U)
}

enum ResponseError: Error {
  case noResults
  
  var reason: String {
    switch self {
    case .noResults:
      return "No results"
    }
  }
}
