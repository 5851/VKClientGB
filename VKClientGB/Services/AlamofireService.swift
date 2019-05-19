import Foundation
import Alamofire

class AlamofireService {
    
    static let shared = AlamofireService()
    
    private init() {  }    
    
    let vkApi = "https://api.vk.com/method/"
    let vkApiFrieds = "friends.get"
    let vkApiGroups = "groups.get"
    let vkApiAllGroups = "groups.search"
    let vkApiAllPhotosFriends = "photos.getAll"
    
    // Fetch friends
    
    func fetchFrieds(completionHandler: @escaping ([Friend]) -> Void) {
        
        let url = vkApi + vkApiFrieds
        
        let parameters: Parameters = [
            "user_id": Session.shared.userId,
            "access_token": Session.shared.token,
            "order": "name",
            "fields": "nickname, photo_100",
            "v": "5.95"
        ]

        Alamofire.request(url, method: .get, parameters: parameters).responseData { data in

            switch data.result {
            case .success(_):
                guard let data = data.data else { return }
                do {
                    let searchResult = try JSONDecoder().decode(FriendsResponseWrapped.self, from: data)
                    completionHandler(searchResult.response.items)
                                    } catch let decodeErr {
                    print("Failed to decode:", decodeErr)
                }
            case .failure(let error):
                print(error)
            }
        }.resume()
    }
    
    // Fetch groups
    
    func fetchMyGroups(completionHandler: @escaping ([Group]) -> Void) {
        
        let url = vkApi + vkApiGroups
        
        let parameters: Parameters = [
            "user_id": Session.shared.userId,
            "access_token": Session.shared.token,
            "extended": 1,
            "v": "5.95"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData { data in
            
            switch data.result {
            case .success(_):
                guard let data = data.data else { return }
                do {
                    let searchResult = try JSONDecoder().decode(GroupsResponseWrapped.self, from: data)
                    let result = searchResult.response.items
                    completionHandler(result)
                } catch let decodeErr {
                    print("Failed to decode:", decodeErr)
                }
            case .failure(let error):
                print(error)
            }
        }.resume()
    }
    
    // Fetch allGroups
    
    func fetchAllGroups(searchText: String, completionHandler: @escaping ([Group]) -> Void) {
        
        let url = vkApi + vkApiAllGroups
        
        let parameters: Parameters = [
            "access_token": Session.shared.token,
            "q": searchText,
            "extended": "1",
            "sort": "3",
            "v": "5.95"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData { data in
            
            switch data.result {
            case .success(_):
                guard let data = data.data else { return }
                do {
                    let searchResult = try JSONDecoder().decode(GroupsResponseWrapped.self, from: data)
                    let result = searchResult.response.items
                    completionHandler(result)
                } catch let decodeErr {
                    print("Failed to decode:", decodeErr)
                }
            case .failure(let error):
                print(error)
            }
        }.resume()
    }
    
    // Fetch photosFriends
    
    func fetchPhotosFriend(friendId: Int, completionHandler: @escaping ([Photo]) -> Void) {
        
        let url = vkApi + vkApiAllPhotosFriends
        
        let parameters: Parameters = [
            "owner_id": friendId,
            "access_token": Session.shared.token,
            "extended": "1",
            "v": "5.95"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData { data in
            
            switch data.result {
            case .success(_):
                guard let data = data.data else { return }
                do {
                    let searchResult = try JSONDecoder().decode(PhotosResponseWrapped.self, from: data)
                    let result = searchResult.response.items
                    completionHandler(result)
                } catch let decodeErr {
                    print("Failed to decode:", decodeErr)
                }
            case .failure(let error):
                print(error)
            }
        }.resume()
    }
}
