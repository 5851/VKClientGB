import UIKit

class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let animationDuration: TimeInterval = 0.6
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        destination.view.frame = source.view.frame
        
        let translation = CGAffineTransform(rotationAngle: 0)
        let scale = CGAffineTransform(scaleX: 1, y: 1)
        destination.view.transform = translation.concatenating(scale)
        source.view.alpha = 1
        
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModePaced, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.3, animations: {
                let translation = CGAffineTransform(rotationAngle: -(.pi/2))
                let scale = CGAffineTransform(scaleX: 1, y: 1)
                source.view.transform = translation.concatenating(scale)
                source.view.alpha = 0
            })
            
        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else if transitionContext.transitionWasCancelled {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
