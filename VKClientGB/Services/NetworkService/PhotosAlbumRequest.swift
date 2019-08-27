import UIKit
import Alamofire

class PhotosAlbumsRequest {
    
    static func fetchPhotosAlbumRequestRouter(urlRequest: URLRequestConvertible,
                                               completionHandler: @escaping (Result<PhotoAlbumResponseWrapped>) -> Void) {
        request(urlRequest).responseData(queue: .global(qos: .userInteractive)) { response in
            let decoder = JSONDecoder()
            let result: Result<PhotoAlbumResponseWrapped> = decoder.decodeResponse(from: response)
            completionHandler(result)
        }
    }
    
    static func fetchPhotosInAlbumRequestRouter(urlRequest: URLRequestConvertible,
                                              completionHandler: @escaping (Result<PhotosInAlbumResponseWrapped>) -> Void) {
        request(urlRequest).responseData(queue: .global(qos: .userInteractive)) { response in
            let decoder = JSONDecoder()
            let result: Result<PhotosInAlbumResponseWrapped> = decoder.decodeResponse(from: response)
            completionHandler(result)
        }
    }
}
