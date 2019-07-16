import Foundation
import Alamofire
import PromiseKit

class FriendsListRequest {
    
    // Fetch friends
    static func fetchFriends(completion: @escaping ([Profile]) -> ()) {
        
        let url = ParametersVK.vkApi + ParametersVK.vkApiFriends

        request(url, method: .get, parameters: ParametersVK.friendsListParameters).validate().responseData { data in
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
    
    // Fetch friends with PromiseKit
    static func fetchFriendsWithPromiseKit() -> Promise<[Profile]> {
        
        let url = ParametersVK.vkApi + ParametersVK.vkApiFriends

        let promise = Promise<[Profile]> { resolver in
            request(url, method: .get, parameters: ParametersVK.friendsListParameters).validate().responseData { data in
                switch data.result {
                case .success(_):
                    guard let data = data.data else { return }
                    do {
                        let objects = try JSONDecoder().decode(ProfilesResponseWrapped.self, from: data)
                        resolver.fulfill(objects.response.items)
                    } catch let decodeErr {
                        print("Failed to decode:", decodeErr)
                    }
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
        return promise
    }
}
