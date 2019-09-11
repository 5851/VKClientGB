import Foundation
import UIKit

class GroupDetailController: BaseListController, UICollectionViewDelegateFlowLayout {

    var group: Group?
    var albums: [PhotoAlbum] = []
    private let imageService = ImageService()
    private var activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        button.tintColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.setTitle("НАЗАД", for: .normal)
        button.setImage(#imageLiteral(resourceName: "backIcon"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 10)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtonView()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GroupDetailHeader.headerId, for: indexPath) as! GroupDetailHeader
        if let group = group {
            header.setupHeaderCell(group: group, imageService: imageService)
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupDetailCell.cellId, for: indexPath) as! GroupDetailCell

        cell.horizontalController.group = group
        cell.horizontalController.collectionView.reloadData()
        cell.horizontalController.didSelectHandler = { [weak self] album in
            let controller = AlbumController()
            controller.album = album
            controller.navigationItem.title = album.title
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 600)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    @objc private func handleBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupButtonView() {
        view.addSubview(button)
        button.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 30, left: 16, bottom: 0, right: 0))
    }
    
    private func setupCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .white
        collectionView.register(GroupDetailCell.self, forCellWithReuseIdentifier: GroupDetailCell.cellId)
        collectionView.register(GroupDetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GroupDetailHeader.headerId)
    }
    
    private func fetchData() {
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        PhotosAlbumsRequest.fetchPhotosAlbumRequestRouter(urlRequest: RequestRouter.getPhotoAlbumGroup(parameters: ParametersVK.photoAlbumParameters(ownerId: -(group?.id ?? 0)))) { (result) in
            dispatchGroup.leave()
            
            switch result {
            case .success(let data):
                let albums = data.response.items
                self.albums = albums
            case .failure(let error):
                print(error)
            }
        }
        
        dispatchGroup.enter()
        MyGroupByIDRequest.fetchUserWithRequestRouter(urlRequest: RequestRouter.getMyGroupsById(parameters: ParametersVK.myGroupsByIDParameters(idGroup: group?.id ?? 0))) { (result) in
            dispatchGroup.leave()
            
            switch result {
            case .success(let data):
                self.group = data.response.first
            case .failure(let error):
                print(error)
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("completed your dispath group tasks...")
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }
}
