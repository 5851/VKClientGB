import UIKit

class SwipeController: UIViewController {
    
    let imagesContainer = UIView()
    var photos = [Photo]()
    var curImageView = UIView()
    var curImageFrame = CGRect()
    
    var currentImage = 0
    var previousImage = 0
    
    var width: CGFloat = 0
    var heigth: CGFloat = 0
    private var offsetValue: CGFloat = 70
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImages()
        setupStartImage()
        setupGesture()
        view.backgroundColor = .black
    }
    
    private func setupStartImage() {
        imagesContainer.frame.origin.x = -width * CGFloat(currentImage)
    }
    
    private func setupImages() {
        width = view.frame.width
        heigth = view.frame.height
        
        imagesContainer.frame = CGRect(x: 0, y: 0, width: width * CGFloat(photos.count), height: heigth)
        for (i, photo) in photos.enumerated() {
            let imageView = WebImageView()
            imageView.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: heigth)
            imageView.contentMode = .scaleAspectFit
            imageView.tag = i

            imageView.set(imageUrl: photo.sizes[2].url)
            
            imagesContainer.addSubview(imageView)
        }
        view.addSubview(imagesContainer)
    }
    
    private func setupGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(imagesSwipe))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(imagesSwipe))
        swipeRight.direction = .right
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(imagesSwipe))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc private func imagesSwipe(gesture: UISwipeGestureRecognizer) {

        switch gesture.direction {
        case .right:
            if (currentImage - 1 >= 0) {
                previousImage = currentImage
                currentImage -= 1
                setupCurrentImage()
            }

        case .left:
            if (currentImage + 1 < photos.count) {
                previousImage = currentImage
                currentImage += 1
                setupCurrentImage()
            }
        case .down:
            dismiss(animated: true, completion: nil)
            imagesContainer.isHidden = true
        default:
            print("No swipe")
        }
    }
    
    private func setupCurrentImage() {
        title = "Фото \(currentImage + 1)/\(photos.count)"
        
        var previousView = UIView()
        var previousFrame = CGRect()
        for view in imagesContainer.subviews {
            if view.tag == previousImage {
                previousView = view
                previousFrame = view.frame
                break
            }
        }
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [], animations: {

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
                previousView.frame = CGRect(x: previousFrame.origin.x + self.offsetValue, y: previousFrame.origin.y + self.offsetValue, width: previousFrame.width - self.offsetValue * 2, height: previousFrame.height - self.offsetValue * 2)
            })

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.imagesContainer.frame.origin.x = -(self.width * CGFloat(self.currentImage))
            })

            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0, animations: {
                previousView.frame = previousFrame
            })

        }, completion: nil)
    }
}
