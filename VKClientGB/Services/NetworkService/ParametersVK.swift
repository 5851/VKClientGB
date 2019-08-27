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
        "fields": "members_count",
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
    
    static let userParameters: Parameters = [
        "access_token": Session.shared.token,
        "user_ids": Session.shared.userId,
        "fields": "photo_100",
        "v": "5.95",
    ]
    
    static let newsFeedParameters: Parameters = [
        "access_token": Session.shared.token,
        "filters": "post",
        "count": "20",
        "v": "5.95",
    ]
    
    static func newsFeedParameters(startFrom: String) -> Parameters {
        let newsFeedParameters: Parameters = [
            "access_token": Session.shared.token,
            "filters": "post",
            "start_from": startFrom,
            "count": "10",
            "v": "5.95",
        ]
        return newsFeedParameters
    }
    
    static func myGroupsByIDParameters(idGroup: Int) -> Parameters {
        
        let myGroupsByIDParameters: Parameters = [
            "user_id": Session.shared.userId,
            "access_token": Session.shared.token,
            "group_ids": idGroup,
            "fields": "members_count",
            "v": "5.95"
        ]
        
        return myGroupsByIDParameters
    }
    
    static func allGroupsParameters(text: String) -> Parameters {
        let parameters: Parameters = [
            "access_token": Session.shared.token,
            "q": text,
            "extended": "1",
            "sort": "3",
            "v": "5.95"
        ]
        return parameters
    }
    
    static func photoParameters(ownerId: Int) -> Parameters {
        let parameters: Parameters = [
            "owner_id": ownerId,
            "access_token": Session.shared.token,
            "extended": "1",
            "count": "200",
            "v": "5.95"
        ]
        return parameters
    }
    
    static func photoAlbumParameters(ownerId: Int) -> Parameters {
        let parameters: Parameters = [
            "owner_id": ownerId,
            "access_token": Session.shared.token,
            "need_covers": "1",
            "photo_sizes": "1",
            "v": "5.95"
        ]
        return parameters
    }
    
    static func photosInAlbumParameters(ownerId: Int, albumId: Int) -> Parameters {
        let parameters: Parameters = [
            "access_token": Session.shared.token,
            "owner_id": -ownerId,
            "album_id": albumId,
            "v": "5.95"
        ]
        return parameters
    }
}
