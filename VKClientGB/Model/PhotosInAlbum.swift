import UIKit

struct PhotosInAlbumResponseWrapped: Decodable {
    let response: PhotosInAlbumResponse
}

struct PhotosInAlbumResponse: Decodable {
    let count: Int
    let items: [PhotosInAlbum]
}

struct PhotosInAlbum: Decodable {
    let id: Int
    let owner_id: Int
    let album_id: Int
    let sizes: [Sizes2]
    
    var srcBIG: String {
        return getSize().url
    }
    
    private func getSize() -> Sizes2 {
        if let sizeX = sizes.first(where: { $0.type == "x" }) {
            return sizeX
        } else if let fallBackSize = sizes.last {
            return fallBackSize
        } else {
            return Sizes2(type: "wrong image", url: "wrong image", width: 0, height: 0)
        }
    }
}

struct Sizes2: Decodable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}
