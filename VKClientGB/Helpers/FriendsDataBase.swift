import UIKit

class FriendsDataBase {
    
    static let shared = FriendsDataBase()
    private init() { }
    
    var friends = [
        Friend(name: "Иванов Иван Иванович", iconImage: UIImage(named: "friend"),photos: [
            UIImage(named: "friend"),
            UIImage(named: "friend"),
            UIImage(named: "friend"),
            UIImage(named: "friend"),
            ]),
        Friend(name: "Петров Петр Петрович", iconImage: UIImage(named: "friend"), photos: [
            UIImage(named: "friend2"),
            UIImage(named: "friend2"),
            UIImage(named: "friend2"),
            UIImage(named: "friend2"),
            ]),
        Friend(name: "Александров Сидор Сидорович", iconImage: UIImage(named: "friend"), photos: [
            UIImage(named: "friend"),
            UIImage(named: "friend2"),
            UIImage(named: "friend3"),
            UIImage(named: "friend4"),
            ]),
        Friend(name: "Сергеев Семен Семенович", iconImage: UIImage(named: "friend"), photos: [
            UIImage(named: "friend4"),
            UIImage(named: "friend4"),
            UIImage(named: "friend4"),
            UIImage(named: "friend4"),
            ]),
        Friend(name: "Сергеев Сергей Сергеевич", iconImage: UIImage(named: "friend"), photos: [
            UIImage(named: "friend5"),
            UIImage(named: "friend5"),
            UIImage(named: "friend5"),
            UIImage(named: "friend5"),
            ]),
        Friend(name: "Сумароков Александр Петрович", iconImage: UIImage(named: "friend"), photos: [
            UIImage(named: "friend2"),
            UIImage(named: "friend2"),
            UIImage(named: "friend2"),
            UIImage(named: "friend2"),
            ]),
        Friend(name: "Державин Гавриил Романович", iconImage: UIImage(named: "friend"), photos: [
            UIImage(named: "friend3"),
            UIImage(named: "friend3"),
            UIImage(named: "friend3"),
            UIImage(named: "friend3"),
            ]),
        Friend(name: "Фонвизин Денис Иванович", iconImage: UIImage(named: "friend"), photos: [
            UIImage(named: "friend4"),
            UIImage(named: "friend4"),
            UIImage(named: "friend4"),
            UIImage(named: "friend4"),
            ]),
        Friend(name: "Радищев Александр Николаевич", iconImage: UIImage(named: "friend"), photos: [
            UIImage(named: "friend5"),
            UIImage(named: "friend5"),
            UIImage(named: "friend5"),
            UIImage(named: "friend5"),
            ]),
        Friend(name: "Карамзин Николай Михайлович", iconImage: UIImage(named: "friend"),photos: [
            UIImage(named: "friend"),
            UIImage(named: "friend"),
            UIImage(named: "friend"),
            UIImage(named: "friend"),
            ]),
        Friend(name: "Крылов Иван Андреевич", iconImage: UIImage(named: "friend"), photos: [
            UIImage(named: "friend2"),
            UIImage(named: "friend2"),
            UIImage(named: "friend2"),
            UIImage(named: "friend2"),
            ]),
        Friend(name: "Жуковский Василий Андреевич", iconImage: UIImage(named: "friend"), photos: [
            UIImage(named: "friend3"),
            UIImage(named: "friend3"),
            UIImage(named: "friend3"),
            UIImage(named: "friend3"),
            ]),
        Friend(name: "Давыдов Денис Васильевич", iconImage: UIImage(named: "friend"), photos: [
            UIImage(named: "friend4"),
            UIImage(named: "friend4"),
            UIImage(named: "friend4"),
            UIImage(named: "friend4"),
            ]),
        Friend(name: "Гнедич Николай Иванович", iconImage: UIImage(named: "friend"), photos: [
            UIImage(named: "friend5"),
            UIImage(named: "friend5"),
            UIImage(named: "friend5"),
            UIImage(named: "friend5"),
            ]),
    ]
    
    var feeds = [
        Feed(feedAuthorIcon: #imageLiteral(resourceName: "friend"),feedAuthor: "Иванов Иван Иванович", feedDate: "12.04.2019", feedDescription: "Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость", feedLikesCount: "10", feedCommentsCount: "10", feedViewsCount: "10", feedRepostsCount: "10", feedImages: [#imageLiteral(resourceName: "friend3"), #imageLiteral(resourceName: "friend4"), #imageLiteral(resourceName: "friend5"), #imageLiteral(resourceName: "friend")]),
        Feed(feedAuthorIcon: #imageLiteral(resourceName: "friend"), feedAuthor: "Сергеев Иван Иванович", feedDate: "12.04.2019", feedDescription: "Новость", feedLikesCount: "10", feedCommentsCount: "10", feedViewsCount: "10", feedRepostsCount: "10", feedImages: [#imageLiteral(resourceName: "friend3"), #imageLiteral(resourceName: "friend4"), #imageLiteral(resourceName: "friend5"), #imageLiteral(resourceName: "friend")]),
        Feed(feedAuthorIcon: #imageLiteral(resourceName: "friend"), feedAuthor: "Петров Иван Иванович", feedDate: "12.04.2019", feedDescription: "Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость Новость", feedLikesCount: "10", feedCommentsCount: "10", feedViewsCount: "10", feedRepostsCount: "10", feedImages: [#imageLiteral(resourceName: "friend3"), #imageLiteral(resourceName: "friend4"), #imageLiteral(resourceName: "friend5"), #imageLiteral(resourceName: "friend")]),
    ]
}
