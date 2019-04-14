import UIKit

class GroupsCell: UITableViewCell {
    
    static var cellId = "groupsCell"
    
    var group: Group! {
        didSet {
            self.iconGroup.image = group.iconImage
            self.nameGroup.text = group.name
        }
    }

    @IBOutlet weak var iconGroup: UIImageView! {
        didSet {
            iconGroup.layer.cornerRadius = iconGroup.frame.width / 2
            iconGroup.contentMode = .scaleAspectFill
            iconGroup.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameGroup: UILabel!
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
