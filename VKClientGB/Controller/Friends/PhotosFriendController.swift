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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
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

    @objc private func cellLikePressed(_ sender: LikeControl) {

    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showImages" {
            let imagesController = segue.destination as? SwipeController
            if let photos: [UIImage] = photos as? [UIImage] {
                imagesController?.photos = photos
            }
            currentImage = collectionView.indexPathsForSelectedItems?.first?.row ?? 0
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
