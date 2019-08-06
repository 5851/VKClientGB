import Foundation
import RealmSwift

//class BaseGroupProtocol: Object, Decodable {
//    @objc dynamic var id = 0
//    @objc dynamic var name = ""
//    @objc dynamic var photo_100: String = ""
//    @objc dynamic var is_closed: Int = 0
//
//    private enum CodingKeys: String, CodingKey {
//        case id, name, photo_100, is_closed
//    }
//
//    override static func primaryKey() -> String? {
//        return "id"
//    }
//}

class AllGroupsResponseWrapped: Decodable {
    let response: AllGroupsResponse
}

class AllGroupsResponse: Decodable {
    let count: Int
    let items: [AllGroup]
}

class AllGroup: Object, Decodable {
    
//    @objc dynamic var animal: BaseGroupProtocol
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var photo_100: String = ""
    @objc dynamic var is_closed: Int = 0
    
    private enum CodingKeys: String, CodingKey {
        case id, name, photo_100, is_closed
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.is_closed = try container.decode(Int.self, forKey: .is_closed)
        self.photo_100 = try container.decode(String.self, forKey: .photo_100)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
