import UIKit

class MyFriendsCell: UITableViewCell {
    
    static var cellId = "myFriendsCell"

    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.75 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 15 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
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
            shadowView.layer.shadowOffset = shadowOffset
            shadowView.layer.shadowOpacity = shadowOpacity
            shadowView.layer.shadowRadius = shadowRadius
            shadowView.backgroundColor = UIColor.black
            shadowView.layer.cornerRadius = shadowView.frame.width / 2
        }
    }
}
