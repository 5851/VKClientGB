import UIKit
import Kingfisher

class PhotosFriendCell: UICollectionViewCell {
    
    static let cellId = "photosFriendCell"
    
    func setupCell(photos: Photo) {
        
        let imageString = photos.sizes[2].url
        let iconUrl = URL(string: imageString)
        photo.kf.setImage(with: iconUrl)
        
//        guard let url = URL(string: photo.sizes[2].url) else { return }
//        guard let data = try? Data(contentsOf: url) else { return }
//
//        DispatchQueue.main.async {
//            self.photo.image = UIImage(data: data)
//        }
    }
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil
    }
}
