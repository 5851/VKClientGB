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
}
