import UIKit

class MyFriendsCell: UITableViewCell {
    
    static var cellId = "myFriendsCell"
    
    @IBOutlet weak var nameFriend: UILabel!
    @IBOutlet weak var iconFriend: WebImageView! {
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
    
    func setupCell(friend: Profile) {
        reset()
        self.nameFriend.text = friend.last_name + " " + friend.first_name
        self.iconFriend.set(imageUrl: friend.photo_100)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconFriend.image = nil
        nameFriend.text = ""
    }
    
    private func reset() {
        iconFriend.image = nil
    }
}
