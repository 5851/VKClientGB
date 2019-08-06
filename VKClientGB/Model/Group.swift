import Foundation
import RealmSwift

class GroupsResponseWrapped: Decodable {
    let response: GroupsResponse
}

class GroupsResponse: Decodable {
    let count: Int
    let items: [Group]
}

class Group: Object, Decodable {

    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var photo_100: String = ""
    @objc dynamic var is_closed: Int = 0
    @objc dynamic var members_count: Int = 0
    
    private enum CodingKeys: String, CodingKey {
        case id, name, photo_100, members_count, is_closed
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.is_closed = try container.decode(Int.self, forKey: .is_closed)
        self.photo_100 = try container.decode(String.self, forKey: .photo_100)
        self.members_count = try container.decode(Int.self, forKey: .members_count)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

