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
    
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.layer.shadowOffset = .zero
            shadowView.layer.shadowOpacity = 0.75
            shadowView.layer.shadowRadius = 5
            shadowView.backgroundColor = UIColor.black
            shadowView.layer.cornerRadius = shadowView.frame.width / 2
        }
    }
}
