import UIKit

class AlbumController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var currentImage = 0
    var album: PhotoAlbum?
    var photosInAlbum: [PhotosInAlbum] = []
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
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AlbumControllerCell.self, forCellWithReuseIdentifier: AlbumControllerCell.cellId)
        collectionView.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        navigationController?.navigationBar.isHidden = false
    }
    
    private func fetchData() {
        PhotosAlbumsRequest.fetchPhotosInAlbumRequestRouter(urlRequest: RequestRouter.getPhotosInAlbum(parameters: ParametersVK.photosInAlbumParameters(ownerId: -(album?.owner_id ?? 0), albumId: album?.id ?? 0))) { (result) in
            
            switch result {
            case .success(let data):
                let photos = data.response.items
                self.photosInAlbum = photos
                
                photos.forEach({ (album) in
                    print(album.album_id)
                    print(album.owner_id)
                })
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosInAlbum.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumControllerCell.cellId, for: indexPath) as! AlbumControllerCell
        
        let album = photosInAlbum[indexPath.row]
        cell.setupCell(album: album, imageService: imageService)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 3
        let height = collectionView.frame.height / 4
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
