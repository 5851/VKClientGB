import UIKit

class PhotosFriendCell: UICollectionViewCell {
    
    static let cellId = "photosFriendCell"
    
    var photoFriend: Photo! {
        didSet {
            let url = URL(string: photoFriend.sizes[2].url)
            guard let data = try? Data(contentsOf: url!) else { return }
            self.photo.image = UIImage(data: data)
        }
    }
    
    @IBOutlet weak var likeNumber: UILabel!
    @IBOutlet weak var photo: WebImageView! {
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
