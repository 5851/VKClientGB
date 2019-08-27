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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(GroupDetailCell.self, forCellWithReuseIdentifier: GroupDetailCell.cellId)
        fetchData()
        collectionView.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupDetailCell.cellId, for: indexPath) as! GroupDetailCell
        
        let album = albums[indexPath.row]
        cell.setupCell(album: album, imageService: imageService)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 48, height: (view.frame.height - 40) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let album = albums[indexPath.row]
        let controller = AlbumController()
        controller.album = album
        controller.navigationItem.title = album.title
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func fetchData() {
        
        PhotosAlbumsRequest.fetchPhotosAlbumRequestRouter(urlRequest: RequestRouter.getPhotoAlbumGroup(parameters: ParametersVK.photoAlbumParameters(ownerId: -(group?.id ?? 0)))) { (result) in
            
            switch result {
            case .success(let data):
                let albums = data.response.items
                self.albums = albums
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
