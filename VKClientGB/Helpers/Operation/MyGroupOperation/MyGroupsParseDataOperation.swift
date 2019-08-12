import UIKit
import Alamofire

class MyGroupsParseDataOperation: Operation {
    
    var groups: [Group] = []
    
    override func main() {
        guard let dataOperation = dependencies.first(where: { $0 is MyGroupsFetchDataOperation }) as? MyGroupsFetchDataOperation,
            let data = dataOperation.data,
            let responseData = try? JSONDecoder().decode(GroupsResponseWrapped.self, from: data) else { return }
        groups = responseData.response.items
    }
}
