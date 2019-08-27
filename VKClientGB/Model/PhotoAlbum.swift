import UIKit

class PhotoAlbumResponseWrapped: Decodable {
    let response: PhotoAlbumResponse
}

class PhotoAlbumResponse: Decodable {
    let count: Int
    let items: [PhotoAlbum]
}

class PhotoAlbum: Decodable {
    let id: Int
    let owner_id: Int
    let title: String
    let sizes: [SizePhotoCover]
    
    var srcBIG: String {
        return getSize().src
    }
    
    private func getSize() -> SizePhotoCover {
        if let sizeX = sizes.first(where: { $0.type == "x" }) {
            return sizeX
        } else if let fallBackSize = sizes.last {
            return fallBackSize
        } else {
            return SizePhotoCover(type: "wrong image", src: "wrong image", width: 0, height: 0)
        }
    }
}

class SizePhotoCover: Decodable {
    var type: String
    var src: String
    var width: Int
    var height: Int
    
    init(type: String, src: String, width: Int, height: Int) {
        self.type = type
        self.src = src
        self.width = width
        self.height = height
    }
}
