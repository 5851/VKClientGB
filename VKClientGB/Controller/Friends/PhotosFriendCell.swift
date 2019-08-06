import UIKit
import Kingfisher

class PhotosFriendCell: UICollectionViewCell {
    
    static let cellId = "photosFriendCell"

    // Base Layer
    private let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    // First layer
    
    var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    // Second layer
    private let iconPhoto: UIImageView = {
        let photoView = UIImageView()
        photoView.clipsToBounds = true
        photoView.contentMode = .scaleAspectFill
        return photoView
    }()
    
    private let likesView: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return view
    }()
    
    private let repostsView: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return view
    }()
    
    // Third layer on bottom view
    private let likeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "like")
        return imageView
    }()
    
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let repostImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "share")
        return imageView
    }()
    
    private let repostLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
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
    
        setupBaseLayer()
        setupFirstLayer()
        setupSecondLayer()
        setupThirdLayerOnBottomView()
    }
    
    private func setupBaseLayer() {
        addSubview(baseView)
        baseView.fillSuperview(padding: .init(top: 10, left: 0, bottom: 0, right: 0))
    }
    
    private func setupFirstLayer() {
        verticalStackView = UIStackView(arrangedSubviews: [
            iconPhoto,
            UIStackView(arrangedSubviews: [
                likesView, UIView(),repostsView
                ])
            ])
        baseView.addSubview(verticalStackView)
        verticalStackView.fillSuperview(padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        verticalStackView.spacing = 10
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
    }
    
    private func setupSecondLayer() {
        iconPhoto.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        likesView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 10, right: 0))
        repostsView.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 10))
    }
    
    private func setupThirdLayerOnBottomView() {
        likesView.addSubview(likeImage)
        likesView.addSubview(likeLabel)
        
        repostsView.addSubview(repostImage)
        repostsView.addSubview(repostLabel)
        
        likeImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        likeImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        likeImage.anchor(top: likesView.topAnchor, leading: likesView.leadingAnchor, bottom: likesView.bottomAnchor, trailing: nil)
        
        likeLabel.anchor(top: likesView.topAnchor, leading: likeImage.trailingAnchor, bottom: likesView.bottomAnchor, trailing: likesView.trailingAnchor)
        
        repostImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        repostImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        repostImage.anchor(top: repostsView.topAnchor, leading: repostsView.leadingAnchor, bottom: repostsView.bottomAnchor, trailing: nil)
        
        repostLabel.anchor(top: repostsView.topAnchor, leading: repostImage.trailingAnchor, bottom: repostsView.bottomAnchor, trailing: repostsView.trailingAnchor)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconPhoto.image = nil
    }
    
    func setupCell(photos: Photo, by imageService: ImageService) {
        
        likeLabel.text = "\(photos.likes[0].count)"
        repostLabel.text = "\(photos.reposts[0].count)"
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
