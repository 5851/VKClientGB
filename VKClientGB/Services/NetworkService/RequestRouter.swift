import Foundation
import Alamofire

enum RequestRouter: URLRequestConvertible {

    static let basicURLString = "https://api.vk.com/method/"
    
    case getMyGroups(parameters: Parameters)
    case getAllGroups
    case getMyFriends
    
    case getPhotoFriends
    case getNewsFeed(parameters: Parameters)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
                case .getMyGroups,
                     .getAllGroups,
                     .getMyFriends,
                     .getPhotoFriends,
                     .getNewsFeed:
                return .get
            }
        }
        
        let url: URL = {
            let relativePath: String
            switch self {
            case .getMyGroups:
                relativePath = "groups.get"
            case .getAllGroups:
                relativePath = "groups.search"
            case .getMyFriends:
                relativePath = "friends.get"
            case .getPhotoFriends:
                relativePath = "friends.get"
            case .getNewsFeed:
                relativePath = "newsfeed.get"
            }
            
            var url = URL(string: RequestRouter.basicURLString)!
            url.appendPathComponent(relativePath)
            return url
        }()
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        switch self {
        case .getMyGroups(let parameters):
            request = try URLEncoding.default.encode(request, with: parameters)
        case .getAllGroups:
            request = try URLEncoding.default.encode(request, with: nil)
        case .getMyFriends:
            request = try URLEncoding.default.encode(request, with: nil)
        case .getPhotoFriends:
            request = try URLEncoding.default.encode(request, with: nil)
        case .getNewsFeed(let parameters):
            request = try URLEncoding.default.encode(request, with: parameters)
        }
        return request
    }
}
