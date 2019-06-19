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
    @objc dynamic var id: Int = 0
    @objc dynamic var owner_id: Int = 0
    let sizes = List<SizePhoto>()
    var friends = LinkingObjects(fromType: Friend.self, property: "photos")
    
    private enum CodingKeys: String, CodingKey {
        case id, owner_id, sizes
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.owner_id = try container.decode(Int.self, forKey: .owner_id)
        
        let photosSize = try container.decodeIfPresent([SizePhoto].self, forKey: .sizes) ?? [SizePhoto()]
        sizes.append(objectsIn: photosSize)
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}

class SizePhoto: Object, Decodable {
    @objc dynamic var type: String = ""
    @objc dynamic var url: String = ""
}
