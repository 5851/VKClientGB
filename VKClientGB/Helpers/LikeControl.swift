import UIKit

class LikeControl: UIControl {
    
    public var isLiked: Bool = false
    let heartImageView = UIImageView()
    let likeNumber = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    private func setupView() {
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        heartImageView.isUserInteractionEnabled = true
        heartImageView.addGestureRecognizer(tapGR)
        
        let stackView = UIStackView(arrangedSubviews: [
            heartImageView, likeNumber
            ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        addSubview(stackView)
        
        heartImageView.image = UIImage(named: "heart")
        
        likeNumber.text = "0"
        likeNumber.textAlignment = .center
        
        backgroundColor = .clear
    }
    
    //MARK: - Privates
    @objc func likeTapped() {
        isLiked.toggle()
        heartImageView.image = isLiked ? UIImage(named: "heartSelected") : UIImage(named: "heart")
        likeNumber.text = isLiked ? "1" : "0"
        likeNumber.textColor = isLiked ? .red : .black
        sendActions(for: .valueChanged)
    }
}
