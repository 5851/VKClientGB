import UIKit
import Kingfisher

class PhotosFriendCell: UICollectionViewCell {
    
    static let cellId = "photosFriendCell"

    var iconPhoto: UIImageView = {
        let photoView = UIImageView()
        photoView.layer.cornerRadius = 12
        photoView.clipsToBounds = true
        photoView.contentMode = .scaleAspectFill
        return photoView
    }()
    var likeControl: LikeControl! = {
        let control = LikeControl()
        control.isOpaque = true
        control.backgroundColor = .blue
        return control
    }()

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        addSubview(likeControl)
//        fillSuperview()
        
        addSubview(iconPhoto)
        iconPhoto.fillSuperview(padding: .init(top: 10, left: 0, bottom: 0, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconPhoto.image = nil
    }
    
    func setupCell(photos: Photo, by imageService: ImageService) {
        
        let imageString = photos.sizes[2].url
        imageService.photo(with: imageString).done(on: DispatchQueue.main) { [weak self] image in
            guard let self = self else { return }
            self.iconPhoto.image = image
            } .catch { error in
                print(error)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
