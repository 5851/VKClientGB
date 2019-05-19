import UIKit

struct GroupsResponseWrapped: Decodable {
    let response: GroupsResponse
}

struct GroupsResponse: Decodable {
    let count: Int
    let items: [Group]
}

struct Group: Decodable {
    let name: String
    let photo_100: String
}
