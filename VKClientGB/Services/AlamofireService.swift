import Foundation
import Alamofire

class AlamofireService {
    
    static let shared = AlamofireService()
    
    private init() {  }    
    
    let vkApi = "https://api.vk.com/method/"
    let vkApiFriends = "friends.get"
    let vkApiGroups = "groups.get"
    let vkApiAllGroups = "groups.search"
    let vkApiJoinGroups = "groups.search"
    let vkApiAllPhotosFriends = "photos.getAll"
    let vkApiNewsFeed = "newsfeed.get"
    
    // Fetch newsfeed
    
    func fetchNewsFeed(completion: @escaping (NewsFeedResponse) -> ()) {
        
        let url = vkApi + vkApiNewsFeed
        
        let parameters: Parameters = [
            "access_token": Session.shared.token,
            "filters": "post",
            "count":"20",
            "v": "5.95",
        ]
        
        request(url, method: .get, parameters: parameters).validate().responseData { data in
            switch data.result {
            case .success(_):
                guard let data = data.data else { return }
                do {
                    let objects = try JSONDecoder().decode(NewsFeedResponseWrapped.self, from: data)
                    completion(objects.response)
                } catch let decodeErr {
                    print("Failed to decode:", decodeErr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Fetch friends
    
    func fetchFrieds(completion: @escaping ([Profile]) -> ()) {
        
        let url = vkApi + vkApiFriends
        
        let parameters: Parameters = [
            "user_id": Session.shared.userId,
            "access_token": Session.shared.token,
            "order": "name",
            "fields": "nickname, photo_100",
            "v": "5.95"
        ]
        
        request(url, method: .get, parameters: parameters).validate().responseData { data in
            switch data.result {
            case .success(_):
                guard let data = data.data else { return }
                do {
                    let objects = try JSONDecoder().decode(ProfilesResponseWrapped.self, from: data)
                    
                    completion(objects.response.items)
                } catch let decodeErr {
                    print("Failed to decode:", decodeErr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Fetch groups
    
    func fetchMyGroups() {
        
        let url = vkApi + vkApiGroups
        
        let parameters: Parameters = [
            "user_id": Session.shared.userId,
            "access_token": Session.shared.token,
//            "fields": "description,members_count",
            "extended": 1,
            "v": "5.95"
        ]

        request(url, method: .get, parameters: parameters).validate().responseData { data in
            switch data.result {
            case .success(_):
                guard let data = data.data else { return }
                do {
                    let objects = try JSONDecoder().decode(GroupsResponseWrapped.self, from: data)

                    try RealmService.save(items: objects.response.items)
                } catch let decodeErr {
                    print("Failed to decode:", decodeErr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    // Fetch allGroups
    
    func fetchAllGroups(searchText: String, completionHandler: @escaping (GroupsResponseWrapped) -> Void) {
        
        let url = vkApi + vkApiAllGroups
        
        let parameters: Parameters = [
            "access_token": Session.shared.token,
            "q": searchText,
            "extended": "1",
            "sort": "3",
            "v": "5.95"
        ]
        fetchGenericJSONData(urlString: url, parameters: parameters, completion: completionHandler)
    }
    
    // Fetch photosFriends
    
    func fetchPhotosFriend(friendId: Int) {
        
        let url = vkApi + vkApiAllPhotosFriends
        
        let parameters: Parameters = [
            "owner_id": friendId,
            "access_token": Session.shared.token,
            "extended": "1",
            "count": "200",
            "v": "5.95"
        ]
        
        request(url, method: .get, parameters: parameters).validate().responseData { data in
            switch data.result {
            case .success(_):
                guard let data = data.data else { return }
                do {
                    let objects = try JSONDecoder().decode(PhotosResponseWrapped.self, from: data).response.items
                    
                    RealmService.savePhotos(objects, friendId: friendId)
                } catch let decodeErr {
                    print("Failed to decode:", decodeErr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Model fetching
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, parameters: Parameters, completion: @escaping (T) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        request(url, method: .get, parameters: parameters).validate().responseData { data in
            switch data.result {
            case .success(_):
                guard let data = data.data else { return }
                do {
                    let objects = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(objects)
                    }
                } catch let decodeErr {
                    print("Failed to decode:", decodeErr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
