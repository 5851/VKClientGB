import UIKit
import RealmSwift

class SwipeController2: UIViewController {
    
    let photoDeckView = UIView()
    let imageService = ImageService()
    var photos: Results<Photo> = try! RealmService.get(Photo.self)
    var currentImage = 0
    let cardViewModel: [CardViewModel] = {
        var photos1: Results<Photo> = try! RealmService.get(Photo.self)
        var producers = Array(photos1)
        
        let viewModels = producers.map( { return $0.toCardViewModel() })
        return viewModels
    }()
    
    override func viewDidLoad() {
        
        setupPhotosCards()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    private func setupPhotosCards() {
        cardViewModel.forEach { photo in
            let photoView = PhotoView(frame: .zero)
            photoView.cardViewModel = photo
            photoDeckView.addSubview(photoView)
            photoView.fillSuperview()
        }
        
        view.addSubview(photoDeckView)
        photoDeckView.fillSuperview()
    }
    
    @objc private func handleSwipeDown(gesture: UISwipeGestureRecognizer) {
        
        switch gesture.direction {
        case .down:
            dismiss(animated: true, completion: nil)
            photoDeckView.isHidden = true
        default:
            print("No swipe")
        }
    }
}
