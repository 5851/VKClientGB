import UIKit
import RealmSwift
import PromiseKit
import RxSwift

class PhotosFriendController: UICollectionViewController {

    // MARK: - Variables
    private var photosToken: NotificationToken?
    private let imageService = ImageService()
    
    var friendId: Int = 0
    var currentImage = 0
    private lazy var photos: Results<Photo> = try! RealmService.get(Photo.self).filter("owner_id == %@", friendId)
    private let disposeBag = DisposeBag()
    
    // MARK: - Controller lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        //  Стандартный вариант (работает)
//        PhotosFriendsRequest.fetchPhotosFriend(friendId: friendId)
        
        // Вариант с PromiseKit and URLSession (работает)
//        PhotosFriendsRequest.fetchPhotosFriendWithPromise(friendId: friendId)
//            .done { [weak self] photos in
//                guard let self = self else { return }
//                print(self.friendId)
//                RealmService.savePhotos(photos, friendId: self.friendId)
//                self.collectionView.reloadData()
//            }.catch { error in
//                print(error)
//        }
        
        // Вариант с PromiseKit and Decodable (работает у меня на swift 4.2)
//        PhotosFriendsRequest.fetchPhotosFriendWithPromiseDecodable(friendId: friendId, on: .global())
//            .get { [weak self] photos in
//                guard let self = self else { return }
//                RealmService.savePhotos(photos.response.items, friendId: self.friendId)
//            }.done(on: .main) { [weak self] photos in
//                guard let self = self else { return }
//                self.collectionView.reloadData()
//            }.catch { error in
//                print(error)
//        }
        
        // Вариант с PromiseKit and RxSwift (работает)
        PhotosFriendsRequest.fetchPhotosFriendWithRxSwift(friendId: friendId)
            .subscribe(onSuccess: { [unowned self] photos in
                print(photos)
                RealmService.savePhotos(photos, friendId: self.friendId)
                self.collectionView.reloadData()
            }) { error in
                print(error)
        }.disposed(by: disposeBag)
        
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
        cell.setupCell(photos: photo, by: imageService)
        cell.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        cell.likeButton.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imagesController = SwipeController()
        imagesController.photos = photos
        currentImage = collectionView.indexPathsForSelectedItems?.first?.row ?? 0
        imagesController.currentImage = currentImage
        navigationController?.pushViewController(imagesController, animated: true)
    }
    
    // MARK: - Private functions
    @objc private func cellLikePressed(_ sender: LikeControl) {
        print("Нажатие")
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        collectionView.register(PhotosFriendCell.self, forCellWithReuseIdentifier: PhotosFriendCell.cellId)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    var isLiked = false
    
    @objc private func handleLike(sender: UIButton) {
        if isLiked {
            sender.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal), for: .normal)
            isLiked = false
        } else {
            sender.setImage(#imageLiteral(resourceName: "heartSelected").withRenderingMode(.alwaysOriginal), for: .normal)
            isLiked = true
        }
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosFriendController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width/1.2, height: 400/1.2)
    }
}
