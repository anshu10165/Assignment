import Foundation

protocol FlickrAPI: class {
    func fetchPhotos(text: String,
                     pagenumber: Int,
                     handler: @escaping(Result<FlickrResponse?, ResponseError>) -> Void)
}

class FlickrPhotosRequest: FlickrAPI {
    
    private let urlSession: URLSession
    private let baseURL = "https://api.flickr.com/services/rest/?"
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchPhotos(text: String,
                     pagenumber: Int = 0,
                     handler: @escaping(Result<FlickrResponse?, ResponseError>) -> Void) {
        guard var urlComponents = URLComponents(string: baseURL) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: apiKey()),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "safe_search", value: "1"),
            URLQueryItem(name: "text", value: text),
            URLQueryItem(name: "page", value: String(pagenumber))
        ]
        if let url = urlComponents.url {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlSession.dataTask(with: urlRequest) { (data, response, error) in
                guard let dataResponse = data, error == nil else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let flickrResponse = try decoder.decode(FlickrResponse.self, from: dataResponse)
                    handler(Result.success(flickrResponse))
                } catch _ {
                    handler(Result.failure(ResponseError.noResults))
                }
            }.resume()
        }
    }
    
    private func apiKey() -> String {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "apiKey") as? String {
            return apiKey
        }
        return ""
    }
}
