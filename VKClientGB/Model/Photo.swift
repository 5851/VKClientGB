import Foundation
import RealmSwift

class PhotosResponseWrapped: Decodable {
    let response: PhotosResponse
}

class PhotosResponse: Decodable {
    let count: Int
    let items: [Photo]
}

class Photo: Object, Decodable {

    @objc dynamic var id: Int = 0
    @objc dynamic var owner_id: Int = 0
    let likes = List<LikesCount>()
    let reposts = List<RepostsCount>()
    let sizes = List<SizePhoto>()
    var friends = LinkingObjects(fromType: Profile.self, property: "photos")

    var srcBIG: String {
        return getSize().url
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, owner_id, likes, reposts, sizes
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.owner_id = try container.decode(Int.self, forKey: .owner_id)
        
        let photosSize = try container.decodeIfPresent([SizePhoto].self, forKey: .sizes) ?? [SizePhoto()]
        sizes.append(objectsIn: photosSize)
        
        let likesCount = try container.decodeIfPresent(LikesCount.self, forKey: .likes) ?? LikesCount()
        likes.append(likesCount)
        let repostsCount = try container.decodeIfPresent(RepostsCount.self, forKey: .reposts) ?? RepostsCount()
        reposts.append(repostsCount)
    }
    
    private func getSize() -> SizePhoto {
        if let sizeX = sizes.first(where: { $0.type == "x" }) {
            return sizeX
        } else if let fallBackSize = sizes.last {
            return fallBackSize
        } else {
            return SizePhoto(type: "wrong image", url: "wrong image", width: 0, height: 0)
        }
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}

class SizePhoto: Object, Decodable {
    @objc dynamic var type: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    
    convenience init(type: String, url: String, width: Int, height: Int) {
        self.init()
        self.type = type
        self.url = url
        self.width = width
        self.height = height
    }
}

class LikesCount: Object, Decodable {
    @objc dynamic var user_likes: Int = 0
    @objc dynamic var count: Int = 0
}

class RepostsCount: Object, Decodable {
    @objc dynamic var count: Int = 0
}
