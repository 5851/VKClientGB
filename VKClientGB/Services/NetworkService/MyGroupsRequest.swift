import UIKit
import Alamofire

class MyGroupsRequest {

    static func fetchMyGroups() {
        
        let url = ParametersVK.vkApi + ParametersVK.vkApiGroups
        
        request(url, method: .get, parameters: ParametersVK.myGroupsParameters).validate().responseData(queue: .global(qos: .userInteractive)) { data in
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
}
