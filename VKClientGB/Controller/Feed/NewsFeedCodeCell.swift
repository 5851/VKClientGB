import UIKit

protocol FeedCellViewModel {
    var iconUrlString: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    var photoAttachements: [FeedCellPhotoAttachementViewModel] { get }
    var sizes: FeedCellSizes { get }
}

protocol FeedCellSizes {
    var postLabelFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
    var bottomViewFrame: CGRect { get }
    var totalHeight: CGFloat { get }
}

protocol FeedCellPhotoAttachementViewModel {
    var photoUrlString: String? { get }
    var width: Int { get }
    var height: Int { get }
}


class NewsFeedCodeCell: UITableViewCell {
    
    static var cellId = "feedsCell"
    
    //  First layer
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // Second layer
    let topView: UIView = {
        let view = UIView()
        return view
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = ConstantsInsets.postLabelFont
        label.textColor = #colorLiteral(red: 0.1728, green: 0.1764, blue: 0.18, alpha: 1)
        return label
    }()
    
    let newsImage: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9098039216, alpha: 1)
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    // Third layer on topView
    let iconImageView: WebImageView = {
        let iconImageView = WebImageView()
        iconImageView.clipsToBounds = true
        return iconImageView
    }()
    
    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        nameLabel.numberOfLines = 0
        nameLabel.textColor = #colorLiteral(red: 0.1728, green: 0.1764, blue: 0.18, alpha: 1)
        return nameLabel
    }()
    
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        return dateLabel
    }()
    
    // Third layer on bottomView
    let likesView: UIView = {
        let view = UIView()
        return view
    }()
    
    let commentsView: UIView = {
        let view = UIView()
        return view
    }()
    
    let sharesView: UIView = {
        let view = UIView()
        return view
    }()
    
    let viewsView: UIView = {
        let view = UIView()
        return view
    }()
    
    // Fourth layer on bottomView
    let likesImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "like")
        return imageView
    }()
    
    let commentImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "comment")
        return imageView
    }()
    
    let sharesImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "share")
        return imageView
    }()
    
    let viewsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "view")
        return imageView
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let sharesLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let commentsLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let viewsLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        backgroundColor = .clear
        selectionStyle = .none
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        iconImageView.layer.cornerRadius = ConstantsInsets.topViewHeight / 2
        iconImageView.clipsToBounds = true
        
        setupFirstLayer()
        setupSecondLayer()
        setupThirdLayerOnTopView()
        setupThirdLayerOnBottomView()
        setupFourthLayerOnBottomView()
    }
    
    private func setupFirstLayer() {
        addSubview(cardView)
        cardView.fillSuperview(padding: ConstantsInsets.cardInsets)
    }
    
    private func setupSecondLayer() {
        cardView.addSubview(topView)
        cardView.addSubview(postLabel)
        cardView.addSubview(newsImage)
        cardView.addSubview(bottomView)
        
        topView.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, bottom: nil, trailing: cardView.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8))
        topView.heightAnchor.constraint(equalToConstant: ConstantsInsets.topViewHeight).isActive = true
    }
    
    private func setupThirdLayerOnTopView() {
        topView.addSubview(iconImageView)
        topView.addSubview(nameLabel)
        topView.addSubview(dateLabel)
        
        iconImageView.anchor(top: topView.topAnchor, leading: topView.leadingAnchor, bottom: nil, trailing: nil)
        iconImageView.heightAnchor.constraint(equalToConstant: ConstantsInsets.topViewHeight).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: ConstantsInsets.topViewHeight).isActive = true
        
        nameLabel.anchor(top: topView.topAnchor, leading: iconImageView.trailingAnchor, bottom: nil, trailing: topView.trailingAnchor, padding: .init(top: 2, left: 8, bottom: 0, right: 8))
        nameLabel.heightAnchor.constraint(equalToConstant: ConstantsInsets.topViewHeight/2 - 2).isActive = true
        
        dateLabel.anchor(top: nil, leading: iconImageView.trailingAnchor, bottom: topView.bottomAnchor, trailing: topView.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 2, right: 8))
        dateLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    private func setupThirdLayerOnBottomView() {
        bottomView.addSubview(likesView)
        bottomView.addSubview(commentsView)
        bottomView.addSubview(sharesView)
        bottomView.addSubview(viewsView)
        
        likesView.anchor(top: bottomView.topAnchor, leading: bottomView.leadingAnchor, bottom: nil, trailing: nil, size: .init(width: ConstantsInsets.bottomViewWidth, height: ConstantsInsets.bottomViewViewHeight))
        commentsView.anchor(top: bottomView.topAnchor, leading: likesView.trailingAnchor, bottom: nil, trailing: nil, size: .init(width: ConstantsInsets.bottomViewWidth, height: ConstantsInsets.bottomViewViewHeight))
        sharesView.anchor(top: bottomView.topAnchor, leading: commentsView.trailingAnchor, bottom: nil, trailing: nil, size: .init(width: ConstantsInsets.bottomViewWidth, height: ConstantsInsets.bottomViewViewHeight))
        viewsView.anchor(top: bottomView.topAnchor, leading: nil, bottom: nil, trailing: bottomView.trailingAnchor, size: .init(width: ConstantsInsets.bottomViewWidth, height: ConstantsInsets.bottomViewViewHeight))
    }
    
    private func setupFourthLayerOnBottomView() {
        likesView.addSubview(likesImage)
        likesView.addSubview(likesLabel)
        
        commentsView.addSubview(commentImage)
        commentsView.addSubview(commentsLabel)
        
        sharesView.addSubview(sharesImage)
        sharesView.addSubview(sharesLabel)
        
        viewsView.addSubview(viewsImage)
        viewsView.addSubview(viewsLabel)
        
        helpInForLayer(view: likesView, imageView: likesImage, label: likesLabel)
        helpInForLayer(view: commentsView, imageView: commentImage, label: commentsLabel)
        helpInForLayer(view: sharesView, imageView: sharesImage, label: sharesLabel)
        helpInForLayer(view: viewsView, imageView: viewsImage, label: viewsLabel)
    }
    
    private func helpInForLayer(view: UIView, imageView: UIImageView, label: UILabel) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: ConstantsInsets.bottomViewViewsIconSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: ConstantsInsets.bottomViewViewsIconSize).isActive = true
        
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func set(viewModel: FeedCellViewModel, by imageService: ImageService) {
        
        imageService.photo(with: viewModel.iconUrlString).done { [weak self] image in
            guard let self = self else { return }
            self.iconImageView.image = image
            } .catch { error in
                print(error)
        }
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        sharesLabel.text = viewModel.shares
        viewsLabel.text = viewModel.views
        
        
        
        postLabel.frame = viewModel.sizes.postLabelFrame
        newsImage.frame = viewModel.sizes.attachmentFrame
        bottomView.frame = viewModel.sizes.bottomViewFrame
        
        if let photoAttachment = viewModel.photoAttachements.first {
            //            newsImage.set(imageUrl: photoAttachment.photoUrlString)
            imageService.photo(with: photoAttachment.photoUrlString ?? "").done { [weak self] image in
                guard let self = self else { return }
                self.newsImage.image = image
                } .catch { error in
                    print(error)
            }
            newsImage.isHidden = false
            newsImage.frame = viewModel.sizes.attachmentFrame
        } else {
            newsImage.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
