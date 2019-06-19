import UIKit
import RealmSwift

class FriendsResponseWrapped: Decodable {
    let response: FriendsResponse
}

class FriendsResponse: Decodable {
    let count: Int
    let items: [Friend]
}

class Friend: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var first_name: String = ""
    @objc dynamic var last_name: String = ""
    @objc dynamic var photo_100: String = ""
    var photos = List<Photo>()

    private enum CodingKeys: String, CodingKey {
        case id, first_name, last_name, photo_100, photos
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.first_name = try container.decode(String.self, forKey: .first_name)
        self.last_name = try container.decode(String.self, forKey: .last_name)
        self.photo_100 = try container.decode(String.self, forKey: .photo_100)

//        let photosList = try container.decodeIfPresent([Photo].self, forKey: .photos) ?? [Photo()]
//        photos.append(objectsIn: photosList)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
