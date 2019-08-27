import UIKit

class AllGroupsCell: UITableViewCell {
    
    static var cellId = "groupsCell"
    
    // First Layer
    private var horizontalView: UIStackView!
    
    private var iconGroup: UIImageView! = {
        let iconGroup = UIImageView()
        iconGroup.clipsToBounds = true
        iconGroup.heightAnchor.constraint(equalToConstant: 36).isActive = true
        iconGroup.widthAnchor.constraint(equalToConstant: 36).isActive = true
        return iconGroup
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
    
    private let groupView: UIView! = {
        let view = UIView()
        return view
    }()
    
    // Second Layer for groupView
    private var verticalStackView: UIStackView!
    
    private var nameGroup: UILabel! = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private var openGroup: UILabel! = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        iconGroup.layer.cornerRadius = 35 / 2
        iconGroup.clipsToBounds = true
        shadowView.layer.cornerRadius = 35 / 2
        shadowView.clipsToBounds = true
        
        setupBaseLayer()
        setupSecondLayerForBottomView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameGroup.text = ""
        iconGroup.image = nil
    }
    
    private func setupBaseLayer() {
        horizontalView = UIStackView(arrangedSubviews: [
            iconGroup, groupView
            ])
        horizontalView.distribution = .fill
        horizontalView.axis = .horizontal
        horizontalView.spacing = 10
        addSubview(horizontalView)
        horizontalView.fillSuperview(padding: .init(top: 10, left: 16, bottom: 10, right: 16))
    }
    
    private func setupSecondLayerForBottomView() {
        verticalStackView = UIStackView(arrangedSubviews: [
            nameGroup, openGroup
            ])
        verticalStackView.distribution = .fillEqually
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 2
        groupView.addSubview(verticalStackView)
        verticalStackView.fillSuperview(padding: .init(top: 0, left: 10, bottom: 0, right: 0))
    }
    
    func setupCell(group: Group, by imageService: ImageService) {
        let typeGroup = group.is_closed
        if typeGroup == 0 {
            openGroup.text = "Открытая группа"
        } else {
            openGroup.text = "Закрытая группа"
        }
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
