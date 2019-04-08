import UIKit

class PhotosFriendCell: UICollectionViewCell {
    
    static let cellId = "photosFriendCell"
    
    @IBOutlet weak var photo: UIImageView! {
        didSet {
            photo.layer.cornerRadius = 10
            photo.contentMode = .scaleAspectFill
            photo.clipsToBounds = true
        }
    }
}
