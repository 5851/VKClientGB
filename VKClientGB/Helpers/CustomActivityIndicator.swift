import UIKit

class CustomActivityIndicator: UIView {

    private var mainView = UIView()
    private var circle1 = UIView()
    private var circle2 = UIView()
    private var circle3 = UIView()
    private var circle4 = UIView()
    private var circle5 = UIView()
    
    override func draw(_ rect: CGRect) {
        let circleDiameter = CGFloat(10)
        
        mainView.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height)
        mainView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        mainView.layer.cornerRadius = 5
        
        circle1.frame = .init(x: 5, y: 5, width: circleDiameter, height: circleDiameter)
        circle2.frame = .init(x: 18, y: 5, width: circleDiameter, height: circleDiameter)
        circle3.frame = .init(x: 31, y: 5, width: circleDiameter, height: circleDiameter)
        circle4.frame = .init(x: 44, y: 5, width: circleDiameter, height: circleDiameter)
        circle5.frame = .init(x: 57, y: 5, width: circleDiameter, height: circleDiameter)
        
        circle1.layer.cornerRadius = circleDiameter / 2
        circle2.layer.cornerRadius = circleDiameter / 2
        circle3.layer.cornerRadius = circleDiameter / 2
        circle4.layer.cornerRadius = circleDiameter / 2
        circle5.layer.cornerRadius = circleDiameter / 2
        
        circle1.backgroundColor = .gray
        circle2.backgroundColor = .gray
        circle3.backgroundColor = .gray
        circle4.backgroundColor = .gray
        circle5.backgroundColor = .gray
        
        mainView.addSubview(circle1)
        mainView.addSubview(circle2)
        mainView.addSubview(circle3)
        mainView.addSubview(circle4)
        mainView.addSubview(circle5)

        self.addSubview(mainView)
    }

    func startAnimating() {
        
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.repeat, .autoreverse],animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.33, animations: {
                self.circle1.alpha = 0.2
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
                self.circle2.alpha = 0.2
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2, animations: {
                self.circle3.alpha = 0.2
            })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2, animations: {
                self.circle4.alpha = 0.2
            })
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                self.circle5.alpha = 0.2
            })
        }, completion: nil)
    }
    
    func stopAnimating() {
        mainView.layer.removeAllAnimations()
    }
}
