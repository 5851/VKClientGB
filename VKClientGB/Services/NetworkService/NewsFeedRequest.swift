import Foundation
import Alamofire

class NewsFeedRequest {
    
    static func fetchNewsFeed(completion: @escaping (String, NewsFeedResponse) -> ()) {
        
        let url = ParametersVK.vkApi + ParametersVK.vkApiNewsFeed

        request(url, method: .get, parameters: ParametersVK.newsFeedParameters(startFrom: "")).validate().responseData(queue: .global(qos: .userInteractive)) { data in
            switch data.result {
            case .success(_):
                guard let data = data.data else { return }
                do {
                    let objects = try JSONDecoder().decode(NewsFeedResponseWrapped.self, from: data)
                    completion(objects.response.next_from ?? "", objects.response)
                } catch let decodeErr {
                    print("Failed to decode:", decodeErr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Функция с помощью созданного Request Router
    static func fetchNewsFeedWithRequestRouter(urlRequest: URLRequestConvertible,
                               completionHandler: @escaping (Result<NewsFeedResponseWrapped>) -> Void) {
        request(urlRequest).responseData(queue: .global(qos: .userInteractive)) { response in
            let decoder = JSONDecoder()
            let result: Result<NewsFeedResponseWrapped> = decoder.decodeResponse(from: response)
            completionHandler(result)
        }
    }
    
    // Функция с помощью созданного Request Router
    static func fetchNewsFeed2(nextBatchFrom: String, completion: @escaping (NewsFeedResponse) -> ()) {
        
        let url = ParametersVK.vkApi + ParametersVK.vkApiNewsFeed
        
        let newsFeedParameters: Parameters = [
            "access_token": Session.shared.token,
            "filters": "post",
            "start_from": nextBatchFrom,
            "v": "5.95",
        ]
        
        request(url, method: .get, parameters: newsFeedParameters).validate().responseData(queue: .global(qos: .userInteractive)) { data in
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
