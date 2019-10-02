import Foundation

struct FlickrResponse: Decodable {
    let photos: Photos
}

struct Photos: Decodable {
    let page: Int
    let total: String
    let photo: [Photoes]
    let pages: Int
}

struct Photoes: Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
}

