import UIKit

class Feed {
    let feedAuthorIcon: UIImage
    let feedAuthor: String
    let feedDate: String
    let feedDescription: String
    let feedLikesCount: String
    let feedCommentsCount: String
    let feedViewsCount: String
    let feedRepostsCount: String
    let feedImages: [UIImage]
    
    init(feedAuthorIcon: UIImage, feedAuthor: String, feedDate: String, feedDescription: String, feedLikesCount: String, feedCommentsCount: String, feedViewsCount: String, feedRepostsCount: String, feedImages: [UIImage]) {
        self.feedAuthorIcon = feedAuthorIcon
        self.feedAuthor = feedAuthor
        self.feedDate = feedDate
        self.feedDescription = feedDescription
        self.feedLikesCount = feedLikesCount
        self.feedCommentsCount = feedCommentsCount
        self.feedViewsCount = feedViewsCount
        self.feedRepostsCount = feedRepostsCount
        self.feedImages = feedImages
    }
}
