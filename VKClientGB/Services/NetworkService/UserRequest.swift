import Foundation
import Alamofire

class UserRequest {
    static func fetchUserWithRequestRouter(urlRequest: URLRequestConvertible,
                                    completionHandler: @escaping (Result<UserResponseWrapped>) -> Void) {
        request(urlRequest).responseData(queue: .global(qos: .userInteractive)) { response in
            let decoder = JSONDecoder()
            let result: Result<UserResponseWrapped> = decoder.decodeResponse(from: response)
            completionHandler(result)
        }
    }
}


