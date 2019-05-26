import Foundation
import Alamofire

class AlamofireService {
    
    static let shared = AlamofireService()
    
    private init() {  }    
    
    let vkApi = "https://api.vk.com/method/"
    let vkApiFrieds = "friends.get"
    let vkApiGroups = "groups.get"
    let vkApiAllGroups = "groups.search"
    let vkApiJoinGroups = "groups.search"
    let vkApiAllPhotosFriends = "photos.getAll"
    
    // Fetch friends
    
    func fetchFrieds(completionHandler: @escaping (FriendsResponseWrapped) -> Void) {
        
        let url = vkApi + vkApiFrieds
        
        let parameters: Parameters = [
            "user_id": Session.shared.userId,
            "access_token": Session.shared.token,
            "order": "name",
            "fields": "nickname, photo_100",
            "v": "5.95"
        ]
        
        fetchGenericJSONData(urlString: url, parameters: parameters, completion: completionHandler)
    }
    
    // Fetch groups
    
    func fetchMyGroups(completionHandler: @escaping (GroupsResponseWrapped) -> Void) {
        
        let url = vkApi + vkApiGroups
        
        let parameters: Parameters = [
            "user_id": Session.shared.userId,
            "access_token": Session.shared.token,
//            "fields": "description,members_count",
            "extended": 1,
            "v": "5.95"
        ]
        fetchGenericJSONData(urlString: url, parameters: parameters, completion: completionHandler)
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
    
    func fetchPhotosFriend(friendId: Int, completionHandler: @escaping (PhotosResponseWrapped) -> Void) {
        
        let url = vkApi + vkApiAllPhotosFriends
        
        let parameters: Parameters = [
            "owner_id": friendId,
            "access_token": Session.shared.token,
            "extended": "1",
            "v": "5.95"
        ]
        
        fetchGenericJSONData(urlString: url, parameters: parameters, completion: completionHandler)
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
                    print(objects)
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
