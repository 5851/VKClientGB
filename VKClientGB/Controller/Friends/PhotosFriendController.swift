import UIKit
import RealmSwift

class PhotosFriendController: UICollectionViewController {

    // MARK: - Variables
    private var photosToken: NotificationToken?
    
    var friendId: Int = 0
    var currentImage = 0
    private lazy var photos: Results<Photo> = try! RealmService.get(Photo.self).filter("owner_id == %@", friendId)
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AlamofireService.shared.fetchPhotosFriend(friendId: friendId)
        navigationItem.title = "Фотографии друга"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        
        photosToken = photos.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial:
                break
            case .update:
                self.collectionView.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        photosToken?.invalidate()
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosFriendCell.cellId, for: indexPath) as? PhotosFriendCell else {
            fatalError("Can not load cell")
        }
        
        let photo = photos[indexPath.row]
        cell.setupCell(photos: photo)
        cell.likeControl.addTarget(self, action: #selector(cellLikePressed), for: .valueChanged)        
        return cell
    }
    
    // MARK: - Private functions
    @objc private func cellLikePressed(_ sender: LikeControl) {

    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showImages" {
            let imagesController = segue.destination as? SwipeController
            imagesController?.photos = photos
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
