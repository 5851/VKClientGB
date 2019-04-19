import UIKit

class FeedsCell: UITableViewCell {
    
    var feed: Feed! {
        didSet {
            newsAuthorIcon.image = feed.feedAuthorIcon
            newsAuthorLabel.text = feed.feedAuthor
            newsDateLabel.text = feed.feedDate
            newsDescriptionLabel.text = feed.feedDescription
            newsImage1.image = feed.feedImages[0]
            newsImage2.image = feed.feedImages[1]
            newsImage3.image = feed.feedImages[2]
            newsImage4.image = feed.feedImages[3]
            newsLikesCount.text = feed.feedLikesCount
            newsRepostCount.text = feed.feedRepostsCount
            newsCommentCount.text = feed.feedCommentsCount
            newsViewsCount.text = feed.feedViewsCount
        }
    }
    static var cellId = "feedsCell"
    @IBOutlet weak var newsAuthorIcon: UIImageView! {
        didSet {
            newsAuthorIcon.layer.cornerRadius = newsAuthorIcon.frame.width / 2
            newsAuthorIcon.clipsToBounds = true
        }
    }
    @IBOutlet weak var newsAuthorLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    @IBOutlet weak var newsImage1: UIImageView! {
        didSet {
            newsImage1.contentMode = .scaleAspectFill
            newsImage1.clipsToBounds = true
        }
    }
    @IBOutlet weak var newsImage2: UIImageView! {
        didSet {
            newsImage2.contentMode = .scaleAspectFill
            newsImage2.clipsToBounds = true
        }
    }
    @IBOutlet weak var newsImage3: UIImageView! {
        didSet {
            newsImage3.contentMode = .scaleAspectFill
            newsImage3.clipsToBounds = true
        }
    }
    @IBOutlet weak var newsImage4: UIImageView! {
        didSet {
            newsImage4.contentMode = .scaleAspectFill
            newsImage4.clipsToBounds = true
        }
    }
    @IBOutlet weak var newsLikesCount: UILabel!
    @IBOutlet weak var newsRepostCount: UILabel!
    @IBOutlet weak var newsCommentCount: UILabel!
    @IBOutlet weak var newsViewsCount: UILabel!
}
