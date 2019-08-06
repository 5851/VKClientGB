import UIKit

class MyFriendsCell: UITableViewCell {
    
    static var cellId = "myFriendsCell"
    
    private var nameFriend: UILabel! = {
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
    
    var iconFriend: UIImageView! = {
        let iconFriend = UIImageView()
        iconFriend.clipsToBounds = true
        iconFriend.heightAnchor.constraint(equalToConstant: 36).isActive = true
        iconFriend.widthAnchor.constraint(equalToConstant: 36).isActive = true
        return iconFriend
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconFriend.layer.cornerRadius = 36 / 2
        iconFriend.clipsToBounds = true
        shadowView.layer.cornerRadius = 36 / 2
        shadowView.clipsToBounds = true
        
        setupHorizontalStackView()
    }
    
    private func setupHorizontalStackView() {
        
        let horizontaStackView = UIStackView(arrangedSubviews: [
            shadowView, nameFriend
            ])
        addSubview(horizontaStackView)
        horizontaStackView.axis = .horizontal
        horizontaStackView.spacing = 10
        horizontaStackView.fillSuperview(padding: .init(top: 5, left: 16, bottom: 5, right: 16))
        
        addSubview(iconFriend)
        iconFriend.anchor(top: shadowView.topAnchor, leading: shadowView.leadingAnchor, bottom: shadowView.bottomAnchor, trailing: shadowView.trailingAnchor)
    }
    
    
    func setupCell(friend: Profile, by imageService: ImageService) {
        reset()
        self.nameFriend.text = friend.last_name + " " + friend.first_name
        let imageString = friend.photo_100
        imageService.photo(with: imageString).done(on: DispatchQueue.main) { [weak self] image in
            guard let self = self else { return }
            self.iconFriend.image = image
            } .catch { error in
                print(error)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconFriend.image = nil
        nameFriend.text = ""
    }
    
    private func reset() {
        iconFriend.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
