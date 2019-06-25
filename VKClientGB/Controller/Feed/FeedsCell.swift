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
    var photoAttachment: FeedCellPhotoAttachmentViewModel? { get }
}

protocol FeedCellPhotoAttachmentViewModel {
    var photoUrlString: String? { get }
    var width: Int { get }
    var height: Int { get }
}

class FeedsCell: UITableViewCell {
    
    static var cellId = "feedsCell"
    
    @IBOutlet weak var iconImageView: WebImageView! {
        didSet {
            iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
            iconImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var newsImage: WebImageView! {
        didSet {
            newsImage.contentMode = .scaleAspectFill
            newsImage.layer.cornerRadius = 5
            newsImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    func set(viewModel: FeedCellViewModel) {
        iconImageView.set(imageUrl: viewModel.iconUrlString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        sharesLabel.text = viewModel.shares
        viewsLabel.text = viewModel.views
        
        if let photoAttachment = viewModel.photoAttachment {
            newsImage.set(imageUrl: photoAttachment.photoUrlString)
            newsImage.isHidden = false
        } else {
            newsImage.isHidden = true
        }
    }
}
