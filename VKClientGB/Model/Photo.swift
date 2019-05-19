import Foundation

struct PhotosResponseWrapped: Decodable {
    let response: PhotosResponse
}

struct PhotosResponse: Decodable {
    let count: Int
    let items: [Photo]
}

struct Photo: Decodable {
    let owner_id: Int
    let sizes: [SizePhoto]
}

struct SizePhoto: Decodable {
    let type: String
    let url: String
}
