import UIKit
import Alamofire

class ParametersVK {
    
    static let vkApi = "https://api.vk.com/method/"
    static let vkApiFriends = "friends.get"
    static let vkApiGroups = "groups.get"
    static let vkApiAllGroups = "groups.search"
    static let vkApiJoinGroups = "groups.search"
    static let vkApiAllPhotosFriends = "photos.getAll"
    static let vkApiNewsFeed = "newsfeed.get"
    
    static let myGroupsParameters: Parameters = [
        "user_id": Session.shared.userId,
        "access_token": Session.shared.token,
        //            "fields": "description,members_count",
        "extended": 1,
        "v": "5.95"
    ]
    
    static let friendsListParameters: Parameters = [
        "user_id": Session.shared.userId,
        "access_token": Session.shared.token,
        "order": "name",
        "fields": "nickname, photo_100",
        "v": "5.95"
    ]
    
    static let newsFeedParameters: Parameters = [
        "access_token": Session.shared.token,
        "filters": "post",
        "count":"20",
        "v": "5.95",
    ]
}
