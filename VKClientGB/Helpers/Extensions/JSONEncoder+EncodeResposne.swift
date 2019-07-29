import Foundation
import Alamofire

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        guard response.error == nil else {
            print(response.error!)
            return .failure(BackendError.network(error: response.error!))
        }
        
        guard let responseData = response.data else {
            print("Did't get any data from API")
            return .failure(BackendError.unexpectedResponse(reason: "Did not get data in response"))
        }
        
        if let apiProviderError = try? decode(APIProvidedError.self, from: responseData) {
            return .failure(BackendError.apiProvidedError(reason: apiProviderError.message))
        }
        
        do {
            let item = try self.decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("Error trying to convert data to JSON")
            print(error)
            return .failure(BackendError.parsing(error: error))
        }
    }
}
