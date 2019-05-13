import UIKit

class PhotosFriendController: UICollectionViewController {

    // MARK: - Variables
    var photos = [UIImage?]()
    var currentImage = 0
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Фотографии друга"
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosFriendCell.cellId, for: indexPath) as? PhotosFriendCell else {
            fatalError("Can not load cell")
        }
    
        cell.photo.image = photos[indexPath.item]
        cell.likeControl.addTarget(self, action: #selector(cellLikePressed), for: .valueChanged)
        
        return cell
    }
    
<<<<<<< Updated upstream
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        cell.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, animations: {
            cell.transform = .identity
            cell.alpha = 1
        }, completion: nil)
    }
    
    // MARK: - Private functions

=======
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentImage = indexPath.row
//        let imagesController = SwipeController()
////        imagesController.photos = photos as! [UIImage]
//        imagesController.currentImage = currentImage
////        performSegue(withIdentifier: "showImages", sender: nil)
    }
    
    // MARK: - Private functions
>>>>>>> Stashed changes
    @objc private func cellLikePressed(_ sender: LikeControl) {

    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showImages" {
            let imagesController = segue.destination as? SwipeController
            imagesController?.photos = photos as! [UIImage]
            imagesController?.currentImage = currentImage
        }
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosFriendController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width/1.2, height: 400/1.2)
    }
}
