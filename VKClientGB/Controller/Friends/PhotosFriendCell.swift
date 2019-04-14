import UIKit

class PhotosFriendCell: UICollectionViewCell {
    
    static let cellId = "photosFriendCell"

    @IBOutlet weak var likeIconButton: UIButton! = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "heart"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    @IBOutlet weak var likeNumber: UILabel! = {
        let label = UILabel()
        return label
    }()
    
    @IBOutlet weak var photo: UIImageView! {
        didSet {
            photo.layer.cornerRadius = 10
            photo.contentMode = .scaleAspectFill
            photo.clipsToBounds = true
        }
    }
    
    @IBAction func touch(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            likeIconButton.setImage(UIImage(named: "heartSelected"), for: .selected)
            likeIconButton.backgroundColor = .clear
            likeNumber.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            likeNumber.text = "\(1)"
        } else {
            likeNumber.textColor = .black
            likeNumber.text = "\(0)"
        }
    }
}
