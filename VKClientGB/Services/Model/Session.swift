import Foundation

class Session {
    
    private init() { }
    
    public static let shared = Session()
    
    var token: String = ""
    var userId: Int = 0
}
