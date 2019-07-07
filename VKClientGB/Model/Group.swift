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
    
    private enum CodingKeys: String, CodingKey {
        case id, name, photo_100
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
