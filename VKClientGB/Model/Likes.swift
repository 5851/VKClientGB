import Foundation

struct ResponseLikes: Decodable {
    let response: LikesAddDelete
}

struct LikesAddDelete: Decodable {
    
    enum ResponseKeys: String, CodingKey {
        case response
    }
    
    var likes: Int
}
