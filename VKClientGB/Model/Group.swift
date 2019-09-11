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
    @objc dynamic var photo_200: String = ""
    @objc dynamic var is_closed: Int = 0
    @objc dynamic var members_count: OptionalInt?
    @objc dynamic var descriptionGroup: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, photo_100, photo_200, members_count, is_closed
        case descriptionGroup = "description"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class OptionalInt: Object, Decodable {
    private var numeric = RealmOptional<Int64>()
    
    required public convenience init(from decoder: Decoder) throws {
        self.init()
        
        let singleValueContainer = try decoder.singleValueContainer()
        if singleValueContainer.decodeNil() == false {
            let value = try singleValueContainer.decode(Int64.self)
            numeric = RealmOptional(value)
        }
    }
    
    var value: Int64? {
        return numeric.value
    }
    
    var zeroOrValue: Int64 {
        return numeric.value ?? 0
    }
}

