import UIKit

class MyFriendsCell: UITableViewCell {
    
    static var cellId = "myFriendsCell"
    
    var friend: Friend! {
        didSet {
            nameFriend.text = friend.name
            iconFriend.image = friend.iconImage
        }
    }
    
    @IBOutlet weak var nameFriend: UILabel!
    @IBOutlet weak var iconFriend: UIImageView! {
        didSet {
            iconFriend.layer.cornerRadius = iconFriend.frame.width / 2
            iconFriend.contentMode = .scaleAspectFill
            iconFriend.clipsToBounds = true
        }
    }
}
