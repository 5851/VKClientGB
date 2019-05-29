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
}
