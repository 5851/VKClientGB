import UIKit

class PhotosFriendCell: UICollectionViewCell {
    
    static let cellId = "photosFriendCell"
    
    @IBOutlet weak var likeNumber: UILabel!
    @IBOutlet weak var photo: UIImageView! {
        didSet {
            photo.contentMode = .scaleAspectFill
            photo.layer.cornerRadius = 10
            photo.clipsToBounds = true
        }
    }
    @IBOutlet var likeControl: LikeControl!

    override var isHighlighted: Bool {
        didSet {
            var transform = CGAffineTransform.identity
            if isHighlighted {
                transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            }
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.transform = transform
            })
        }
    }
}
