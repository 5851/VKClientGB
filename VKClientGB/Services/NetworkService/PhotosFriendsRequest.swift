import UIKit
import Alamofire
import PromiseKit
import RxSwift

class PhotosFriendsRequest {
    
    // Fetch photosFriends standart
    static func fetchPhotosFriend(friendId: Int) {
        
        let url = ParametersVK.vkApi + ParametersVK.vkApiAllPhotosFriends
        
        let parameters: Parameters = [
            "owner_id": friendId,
            "access_token": Session.shared.token,
            "extended": "1",
            "count": "200",
            "v": "5.95"
        ]
        
        request(url, method: .get, parameters: parameters).validate().responseData { data in
            switch data.result {
            case .success(_):
                guard let data = data.data else { return }
                do {
                    let objects = try JSONDecoder().decode(PhotosResponseWrapped.self, from: data).response.items
                    
                    RealmService.savePhotos(objects, friendId: friendId)
                } catch let decodeErr {
                    print("Failed to decode:", decodeErr)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Fetch photosFriends with PromiseKit and URLSession
    static func fetchPhotosFriendWithPromise(friendId: Int) -> Promise<[Photo]> {
        
        var urlComponents = URLComponents(string:"https://api.vk.com/method/photos.getAll")!

        urlComponents.queryItems = [
            URLQueryItem(name: "owner_id", value: "\(friendId)"),
            URLQueryItem(name: "access_token", value: "\(Session.shared.token)"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "count", value: "200"),
            URLQueryItem(name: "v", value: "5.95")
        ]
        
        return Promise { seal in
            
            URLSession.shared.dataTask(with: urlComponents.url!) { data, _, error in
                guard let data = data,
                    let result = try? JSONDecoder().decode(PhotosResponseWrapped.self, from: data).response.items else {
                        let genericError = NSError(
                            domain: "PromiseKitTutorial",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                        seal.reject(error ?? genericError)
                        return
                }
                seal.fulfill(result)
                }.resume()
        }
    }
    
    // Fetch photosFriends with PromiseKit and Decodable
    static func fetchPhotosFriendWithPromiseDecodable(friendId: Int, on queue: DispatchQueue = .main) -> Promise<PhotosResponseWrapped> {
        
        let url = ParametersVK.vkApi + ParametersVK.vkApiAllPhotosFriends
        
        let parameters: Parameters = [
            "owner_id": friendId,
            "access_token": Session.shared.token,
            "extended": "1",
            "count": "200",
            "v": "5.95"
        ]

        return request(url, method: .get, parameters: parameters)
            .responseDecodable(PhotosResponseWrapped.self)
    }
    
    // Fetch photosFriends with PromiseKit and RxSwift
    static func fetchPhotosFriendWithRxSwift(friendId: Int, on queue: DispatchQueue = .main) -> Single<[Photo]> {
        
        let url = ParametersVK.vkApi + ParametersVK.vkApiAllPhotosFriends
        
        let parameters: Parameters = [
            "owner_id": friendId,
            "access_token": Session.shared.token,
            "extended": "1",
            "count": "200",
            "v": "5.95"
        ]
        
        let single = Single<[Photo]>.create { (single) -> Disposable in
            
            let request = Alamofire.request(url, method: .get, parameters: parameters).validate().responseData(completionHandler: { data in
                switch data.result {
                case .success(_):
                    guard let data = data.data else { return }
                    do {
                        let objects = try JSONDecoder().decode(PhotosResponseWrapped.self, from: data)
                        single(.success(objects.response.items))
                    } catch let decodeErr {
                        single(.error(decodeErr))
                        print("Failed to decode:", decodeErr)
                    }
                case .failure(let error):
                    single(.error(error))
                }
            })
            return Disposables.create() { request.cancel() }
        }
        return single
    }
}
