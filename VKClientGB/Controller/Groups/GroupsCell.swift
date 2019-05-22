import UIKit

class GroupsCell: UITableViewCell {
    
    static var cellId = "groupsCell"
    
    var group: Group! {
        didSet {
            DispatchQueue.global().async {
                guard let url = URL(string: self.group.photo_100) else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                
                DispatchQueue.main.async {
                    self.iconGroup.image = UIImage(data: data)
                }
            }
            self.nameGroup.text = group.name
        }
    }

    @IBOutlet weak var iconGroup: WebImageView! {
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameGroup.text = ""
        iconGroup.image = nil
    }
}
