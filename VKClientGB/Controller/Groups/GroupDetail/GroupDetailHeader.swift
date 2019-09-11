import UIKit

class GroupDetailHeader: UICollectionReusableView {
    
    static let headerId = "headerId"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel
            ])
        addSubview(imageView)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 30, left: 20, bottom: 0, right: 20))
        stackView.axis = .vertical
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func setupHeaderCell(group: Group, imageService: ImageService) {
        titleLabel.text = group.name
        let imageString = group.photo_200
        imageService.photo(with: imageString).done(on: DispatchQueue.main) { [weak self] image in
            guard let self = self else { return }
            self.imageView.image = image
            } .catch { error in
                print(error)
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
