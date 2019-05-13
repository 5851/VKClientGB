import UIKit

class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let animationDuration: TimeInterval = 0.8
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        destination.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        destination.view.frame = source.view.frame
        destination.view.alpha = 0
        
        let translation = CGAffineTransform(rotationAngle: -(.pi/2))
        let scale = CGAffineTransform(scaleX: 1, y: 1)
        destination.view.transform = translation.concatenating(scale)
        
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [], animations: {

            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.3, animations: {
                let translation = CGAffineTransform(rotationAngle: 0)
                let scale = CGAffineTransform(scaleX: 1, y: 1)
                destination.view.transform = translation.concatenating(scale)
                destination.view.alpha = 1
            })

        }) { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
}
