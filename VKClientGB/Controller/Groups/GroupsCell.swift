import UIKit

class GroupsCell: UITableViewCell {
    
    static var cellId = "groupsCell"

    @IBOutlet weak var iconGroup: UIImageView! {
        didSet {
            iconGroup.layer.cornerRadius = iconGroup.frame.width / 2
            iconGroup.contentMode = .scaleAspectFill
            iconGroup.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameGroup: UILabel!
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.layer.shadowOffset = .zero
            shadowView.layer.shadowOpacity = 0.75
            shadowView.layer.shadowRadius = 5
            shadowView.backgroundColor = UIColor.black
            shadowView.layer.cornerRadius = shadowView.frame.width / 2
        }
    }
    @IBOutlet weak var membersCount: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameGroup.text = ""
        iconGroup.image = nil
    }
    
    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil }
        var counterString = String(counter)
        
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
        
        return counterString
    }
    
    func setupCell(group: Group, by imageService: ImageService) {
        
        nameGroup.text = group.name
        let imageString = group.photo_100
        imageService.photo(with: imageString).done(on: DispatchQueue.main) { [weak self] image in
            guard let self = self else { return }
            self.iconGroup.image = image
            } .catch { error in
                print(error)
        }
    }
}
