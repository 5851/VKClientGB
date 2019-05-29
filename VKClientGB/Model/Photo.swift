import Foundation
import RealmSwift

class PhotosResponseWrapped: Decodable {
    let response: PhotosResponse
}

class PhotosResponse: Decodable {
    let count: Int
    let items: [Photo]
}

class Photo: Object, Decodable {
    @objc dynamic var owner_id: Int = 0
    let sizes = List<SizePhoto>()
    
    private enum CodingKeys: String, CodingKey {
        case owner_id, sizes
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.owner_id = try container.decode(Int.self, forKey: .owner_id)
        let sizesList = try container.decodeIfPresent([SizePhoto].self, forKey: .sizes) ?? [SizePhoto()]
        sizes.append(objectsIn: sizesList)
    }
}

class SizePhoto: Object, Decodable {
    @objc dynamic var type: String = ""
    @objc dynamic var url: String = ""
}
