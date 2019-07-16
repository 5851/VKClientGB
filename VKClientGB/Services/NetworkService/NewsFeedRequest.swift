import Foundation
import Alamofire
import PromiseKit

class NewsFeedRequest {
    
    static func fetchNewsFeed(completion: @escaping (NewsFeedResponse) -> ()) {
        
        let url = ParametersVK.vkApi + ParametersVK.vkApiNewsFeed

        request(url, method: .get, parameters: ParametersVK.newsFeedParameters).validate().responseData(queue: .global(qos: .userInteractive)) { data in
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
}
