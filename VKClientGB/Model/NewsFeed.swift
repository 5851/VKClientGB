import UIKit

struct NewsFeedResponseWrapped: Decodable {
    let response: NewsFeedResponse
}

struct NewsFeedResponse: Decodable {
    var items: [NewsFeedModel]
    var profiles: [ProfileNews]
    var groups: [GroupNews]
}

struct NewsFeedModel: Decodable {
    let source_id: Int
    let post_id: Int
    let text: String?
    let date: Double
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
    let attachments: [Attachments]?
}

struct CountableItem: Decodable {
    let count: Int
}

struct Attachments: Decodable {
    let photo: PhotoFromNews?
}

struct PhotoFromNews: Decodable {
    let sizes: [PhotoSize]
    
    var height: Int {
        return getPropperSize().height
    }
    
    var width: Int {
        return getPropperSize().width
    }
    
    var srcBIG: String {
        return getPropperSize().url
    }
    
    private func getPropperSize() -> PhotoSize {
        if let sizeX = sizes.first(where: { $0.type == "x"}) {
            return sizeX
        } else if let fallBackSize = sizes.last {
            return fallBackSize
        } else {
            return PhotoSize(type: "wrong image", url: "wrong image", width: 0, height: 0)
        }
    }
}

struct PhotoSize: Decodable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}

struct FeedViewModel {
    
    struct Cell: FeedCellViewModel {
        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        
        var photoAttachments: [FeedCellPhotoAttachmentViewModel]
        var sizes: FeedCellSizes
    }
    
    struct FeedCellPhotoAttachment: FeedCellPhotoAttachmentViewModel {
        var photoUrlString: String?
        var width: Int
        var height: Int
    }
    
    let cell: [Cell]
}

protocol ProfileRepresentable {
    
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

struct ProfileNews: Decodable, ProfileRepresentable {
    let id: Int
    let first_name: String
    let last_name: String
    let photo_100: String
    
    var name: String { return first_name + " " + last_name }
    var photo: String { return photo_100 }
}

struct GroupNews: Decodable, ProfileRepresentable {
    var id: Int
    var name: String
    var photo_100: String
    
    var photo: String { return photo_100 }
}
