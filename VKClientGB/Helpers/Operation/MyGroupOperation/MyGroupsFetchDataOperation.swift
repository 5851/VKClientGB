import UIKit
import Alamofire

class MyGroupsFetchDataOperation: AsyncOperation {
    
    let request: DataRequest
    var data: Data? = nil
    
    init(request: DataRequest) {
        self.request = request
    }
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            
            switch response.result {
            case .success(let data):
                self?.data = data
            case .failure(let error):
                print("Проблема получения данных", error)
            }
            
            self?.state = .finished
        }
    }
}

