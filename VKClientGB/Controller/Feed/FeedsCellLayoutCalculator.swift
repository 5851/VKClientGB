import UIKit

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var attachmentFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
}

struct ConstantsInsets {
    static let cardInsets = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
    static let topViewHeight: CGFloat = 60
    static let postLabelInsets = UIEdgeInsets(top: 8 + ConstantsInsets.topViewHeight + 8, left: 8, bottom: 8, right: 8)
    static let postLabelFont = UIFont.systemFont(ofSize: 17)
    static let bottomViewHeight: CGFloat = 44
    
    static let bottomViewViewHeight: CGFloat = 44
    static let bottomViewWidth: CGFloat = 80
    
    static let bottomViewViewsIconSize: CGFloat = 24
}

protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachmants: [FeedCellPhotoAttachementViewModel]) -> FeedCellSizes
}

final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachmants: [FeedCellPhotoAttachementViewModel]) -> FeedCellSizes {

        let cardViewWidth = ceil(screenWidth - ConstantsInsets.cardInsets.left - ConstantsInsets.cardInsets.right)
        
        //  Работа с PostLabelFrame
        var postLableFrame = CGRect(origin: CGPoint(x: ConstantsInsets.postLabelInsets.left, y: ConstantsInsets.postLabelInsets.top),
                                    size: CGSize.zero)
        if let text = postText, !text.isEmpty {
            let width = ceil(cardViewWidth - ConstantsInsets.postLabelInsets.left - ConstantsInsets.postLabelInsets.right)
            let height = ceil(text.height(width: width, font: ConstantsInsets.postLabelFont))
            postLableFrame.size = CGSize(width: width, height: height)
        }
        
        //  Работа с attachmentFrame
        let attachmentTop = postLableFrame.size == CGSize.zero ? ConstantsInsets.postLabelInsets.top : postLableFrame.maxY + ConstantsInsets.postLabelInsets.bottom
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop),
                                    size: CGSize.zero)
        
        if let attachment = photoAttachmants.first {
            let photoHeight: Float = Float(attachment.height)
            let photoWidth: Float = Float(attachment.width)
            let ratio = CGFloat(photoHeight / photoWidth)
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
        let totalHeight = ceil(bottomViewFrame.maxY + ConstantsInsets.cardInsets.bottom)
        
        return Sizes(postLabelFrame: postLableFrame,
                     attachmentFrame: attachmentFrame,
                     bottomViewFrame: bottomViewFrame,
                     totalHeight: totalHeight)
    }
}
