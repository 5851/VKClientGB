import UIKit

struct FriendsResponseWrapped: Decodable {
    let response: FriendsResponse
}

struct FriendsResponse: Decodable {
    let count: Int
    let items: [Friend]
}

struct Friend: Decodable {
    let id: Int
    let first_name: String
    let last_name: String
    let photo_100: String
}
