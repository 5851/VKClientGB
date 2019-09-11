import UIKit

class GroupDetailHorizontalController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let topBottomPadding: CGFloat = 12
    let lineSpacing: CGFloat = 10
    var albums: [PhotoAlbum] = []
    var group: Group?
    private let imageService = ImageService()
    var didSelectHandler: ((PhotoAlbum) -> ())?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        didSelectHandler!(album)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(GroupDetailHorizontalCell.self, forCellWithReuseIdentifier: GroupDetailHorizontalCell.cellId)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupDetailHorizontalCell.cellId, for: indexPath) as! GroupDetailHorizontalCell

        let album = albums[indexPath.row]
        cell.setupCell(album: album, imageService: imageService)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.height - 2 * topBottomPadding - 2 * lineSpacing)
        return .init(width: view.frame.width - 48, height: (height / 3))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: topBottomPadding, left: 0, bottom: topBottomPadding, right: 0)
    }
    
    private func fetchData() { PhotosAlbumsRequest.fetchPhotosAlbumRequestRouter(urlRequest: RequestRouter.getPhotoAlbumGroup(parameters: ParametersVK.photoAlbumParameters(ownerId: -(group?.id ?? 0)))) { (result) in
            
            switch result {
            case .success(let data):
                let albums = data.response.items
                self.albums = albums
            case .failure(let error):
                print(error)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    init() {
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
