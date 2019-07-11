import UIKit

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var attachmentFrame: CGRect
    var bottomView: CGRect
    var totalHeight: CGFloat
}

struct ConstantsInsets {
    static let cardInsets = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
    static let topViewHeight: CGFloat = 53
    static let postLabelInsets = UIEdgeInsets(top: 8 + ConstantsInsets.topViewHeight + 8, left: 8, bottom: 8, right: 8)
    static let postLabelFont = UIFont.systemFont(ofSize: 17)
    static let bottomViewHeight: CGFloat = 44
}

protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachmants: [FeedCellPhotoAttachmentViewModel]) -> FeedCellSizes
}

final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachmants: [FeedCellPhotoAttachmentViewModel]) -> FeedCellSizes {

        let cardViewWidth = screenWidth - ConstantsInsets.cardInsets.left - ConstantsInsets.cardInsets.right
        
        //  Работа с PostLabelFrame
        var postLableFrame = CGRect(origin: CGPoint(x: ConstantsInsets.postLabelInsets.left, y: ConstantsInsets.postLabelInsets.top),
                                    size: CGSize.zero)
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - ConstantsInsets.postLabelInsets.left - ConstantsInsets.postLabelInsets.right
            let height = text.height(width: width, font: ConstantsInsets.postLabelFont)
            postLableFrame.size = CGSize(width: width, height: height)
        }
        
        //  Работа с attachmentFrame
        let attachmentTop = postLableFrame.size == CGSize.zero ? ConstantsInsets.postLabelInsets.top : postLableFrame.maxY + ConstantsInsets.postLabelInsets.bottom
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop),
                                    size: CGSize.zero)
        
        if let attachment = photoAttachmants.first {
            let photoHeight: Float = Float(attachment.height)
            let photoWidth: Float = Float(attachment.width)
            let ratio = ceil(CGFloat(photoHeight / photoWidth))
            if photoAttachmants.count == 1 {
                attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ratio)
            } else if photoAttachmants.count > 1 {
                print("More 1 photo")
                attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ratio)
            }
        }
        
        //  Работа с bottomFrame
        let bottomViewTop = max(postLableFrame.maxY, attachmentFrame.maxY)
        let bottomViewFrame = CGRect(origin: CGPoint(x: ConstantsInsets.postLabelInsets.left, y: bottomViewTop),
                                 size: CGSize(width: cardViewWidth - ConstantsInsets.postLabelInsets.left - ConstantsInsets.postLabelInsets.right, height: ConstantsInsets.bottomViewHeight))
        
        //  Работа с totalHeight
        let totalHeight = bottomViewFrame.maxY + ConstantsInsets.cardInsets.bottom
        
        return Sizes(postLabelFrame: postLableFrame,
                     attachmentFrame: attachmentFrame,
                     bottomView: bottomViewFrame,
                     totalHeight: totalHeight)
    }
}
