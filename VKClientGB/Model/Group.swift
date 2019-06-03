import UIKit
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
//    let description: String
//    let members_count: Int
}
