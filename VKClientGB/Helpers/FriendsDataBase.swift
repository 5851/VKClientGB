import UIKit

class FriendsDataBase {
    
    static let shared = FriendsDataBase()
    
    private init() { }
    
    var feeds = [
        Feed(feedAuthorIcon: #imageLiteral(resourceName: "friend"),feedAuthor: "Иванов Иван Иванович", feedDate: "12.04.2019", feedDescription: "Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость", feedLikesCount: "10", feedCommentsCount: "10", feedViewsCount: "10", feedRepostsCount: "10", feedImages: [#imageLiteral(resourceName: "friend3"), #imageLiteral(resourceName: "friend4"), #imageLiteral(resourceName: "friend5"), #imageLiteral(resourceName: "friend")]),
        Feed(feedAuthorIcon: #imageLiteral(resourceName: "friend"), feedAuthor: "Сергеев Иван Иванович", feedDate: "12.04.2019", feedDescription: "Новость", feedLikesCount: "10", feedCommentsCount: "10", feedViewsCount: "10", feedRepostsCount: "10", feedImages: [#imageLiteral(resourceName: "friend3"), #imageLiteral(resourceName: "friend4"), #imageLiteral(resourceName: "friend5"), #imageLiteral(resourceName: "friend")]),
        Feed(feedAuthorIcon: #imageLiteral(resourceName: "friend"), feedAuthor: "Петров Иван Иванович", feedDate: "12.04.2019", feedDescription: "Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость", feedLikesCount: "10", feedCommentsCount: "10", feedViewsCount: "10", feedRepostsCount: "10", feedImages: [#imageLiteral(resourceName: "friend3"), #imageLiteral(resourceName: "friend4"), #imageLiteral(resourceName: "friend5"), #imageLiteral(resourceName: "friend")]),
    ]
}
