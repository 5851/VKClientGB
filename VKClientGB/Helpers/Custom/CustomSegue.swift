import UIKit

class CustomSegue: UIStoryboardSegue {
    
    let animationDuration: TimeInterval = 1
    
    override func perform() {
        guard let containerView = source.view else { return }
        
        containerView.addSubview(destination.view)
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        destination.view.frame = source.view.frame
        
        let translation = CGAffineTransform(rotationAngle: -(.pi/2))
        let scale = CGAffineTransform(scaleX: 1, y: 1)
        destination.view.transform = translation.concatenating(scale)
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.3, animations: {
                let translation = CGAffineTransform(rotationAngle: 0)
                let scale = CGAffineTransform(scaleX: 1, y: 1)
                self.destination.view.transform = translation.concatenating(scale)
            })
            
        }) { finished in
            self.source.present(self.destination, animated: false)
        }
    }
}
