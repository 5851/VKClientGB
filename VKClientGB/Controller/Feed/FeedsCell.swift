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
    var photoAttachments: [FeedCellPhotoAttachmentViewModel] { get }
    var sizes: FeedCellSizes { get }
}

protocol FeedCellSizes {
    var postLabelFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
    var bottomView: CGRect { get }
    var totalHeight: CGFloat { get }
}

protocol FeedCellPhotoAttachmentViewModel {
    var photoUrlString: String? { get }
    var width: Int { get }
    var height: Int { get }
}

class FeedsCell: UITableViewCell {
    
    static var cellId = "feedsCell"
    
    @IBOutlet weak var cardView: UIView! {
        didSet {
            cardView.layer.cornerRadius = 10
            cardView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
            iconImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView! {
        didSet {
            newsImage.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    override func prepareForReuse() {
        iconImageView.image = nil
        newsImage.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func set(viewModel: FeedCellViewModel, by imageService: ImageService) {
        
        imageService.photo(with: viewModel.iconUrlString).done { [weak self] image in
            guard let self = self else { return }
            self.iconImageView.image = image
            } .catch { error in
                print(error)
        }
//        iconImageView.set(imageUrl: viewModel.iconUrlString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        sharesLabel.text = viewModel.shares
        viewsLabel.text = viewModel.views
        postLabel.frame = viewModel.sizes.postLabelFrame
        bottomView.frame = viewModel.sizes.bottomView
        
        if let photoAttachment = viewModel.photoAttachments.first {
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
}
