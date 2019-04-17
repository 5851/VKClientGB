import UIKit

class PhotosFriendController: UICollectionViewController {

    // MARK: - Variables
    var photos = [UIImage?]()
    
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
    
    @objc private func cellLikePressed(_ sender: LikeControl) {

    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosFriendController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 400)
    }
}
