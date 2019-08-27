import UIKit

class GroupDetailCell: UICollectionViewCell {
    
    static let cellId = "groupDetailCell"
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Album name section"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        
        addSubview(imageView)
        imageView.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
    }
    
    func setupCell(album: PhotoAlbum, imageService: ImageService) {
        titleLabel.text = album.title
        let imageString = album.srcBIG
        imageService.photo(with: imageString).done(on: DispatchQueue.main) { [weak self] image in
            guard let self = self else { return }
            self.imageView.image = image
            } .catch { error in
                print(error)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
