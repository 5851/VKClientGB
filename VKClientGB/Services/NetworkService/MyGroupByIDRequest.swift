import Foundation
import Alamofire

class MyGroupByIDRequest {
    
    static func fetchUserWithRequestRouter(urlRequest: URLRequestConvertible,
                                           completionHandler: @escaping (Result<GroupsByIDResponseWrapped>) -> Void) {
        request(urlRequest).responseData(queue: .global(qos: .userInteractive)) { response in
            let decoder = JSONDecoder()
            let result: Result<GroupsByIDResponseWrapped> = decoder.decodeResponse(from: response)
            completionHandler(result)
        }
    }
}
