import UIKit
import RealmSwift

class UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

class UserResponse: Decodable {
    let photo_100: String?
}
