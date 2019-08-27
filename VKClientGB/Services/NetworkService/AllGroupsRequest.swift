import Foundation
import Alamofire

class AllGroupsRequest {
    
    static func fetchAllGroups(searchText: String, completionHandler: @escaping (GroupsResponseWrapped) -> Void) {
        
        let url = ParametersVK.vkApi + ParametersVK.vkApiAllGroups
        let allGroupParameters = ParametersVK.allGroupsParameters(text: searchText)
        
        fetchGenericJSONData(urlString: url, parameters: allGroupParameters, completion: completionHandler)
    }
    
    // Model fetching
    static func fetchGenericJSONData<T: Decodable>(urlString: String, parameters: Parameters, completion: @escaping (T) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        request(url, method: .get, parameters: parameters).validate().responseData(queue: .global(qos: .userInteractive)) { data in
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
