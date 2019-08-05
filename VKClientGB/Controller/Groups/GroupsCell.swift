import UIKit

class GroupsCell: UITableViewCell {
    
    static var cellId = "groupsCell"

    private var iconGroup: UIImageView! = {
        let iconGroup = UIImageView()
        iconGroup.clipsToBounds = true
        iconGroup.heightAnchor.constraint(equalToConstant: 36).isActive = true
        iconGroup.widthAnchor.constraint(equalToConstant: 36).isActive = true
        return iconGroup
    }()
    
    var nameGroup: UILabel! = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private var shadowView: UIView! = {
        let shadowView = UIView()
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowOpacity = 0.75
        shadowView.layer.shadowRadius = 5
        shadowView.backgroundColor = UIColor.black
        shadowView.layer.cornerRadius = shadowView.frame.width / 2
        shadowView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        shadowView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        return shadowView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconGroup.layer.cornerRadius = 35 / 2
        iconGroup.clipsToBounds = true
        shadowView.layer.cornerRadius = 35 / 2
        shadowView.clipsToBounds = true

        setupHorizontalStackView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameGroup.text = ""
        iconGroup.image = nil
    }
    
    private func setupHorizontalStackView() {
        
        let horizontaStackView = UIStackView(arrangedSubviews: [
            shadowView, nameGroup
            ])
        addSubview(horizontaStackView)
        horizontaStackView.axis = .horizontal
        horizontaStackView.spacing = 10
        horizontaStackView.fillSuperview(padding: .init(top: 5, left: 16, bottom: 5, right: 16))
        
        addSubview(iconGroup)
        iconGroup.anchor(top: shadowView.topAnchor, leading: shadowView.leadingAnchor, bottom: shadowView.bottomAnchor, trailing: shadowView.trailingAnchor)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
