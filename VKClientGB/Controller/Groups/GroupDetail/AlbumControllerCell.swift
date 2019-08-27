import UIKit

class AlbumControllerCell: UICollectionViewCell {
    
    static let cellId = "cellId"
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.fillSuperview()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
    }
    
    func setupCell(album: PhotosInAlbum, imageService: ImageService) {
        let imageString = album.srcBIG
        imageService.photo(with: imageString).done(on: DispatchQueue.main) { [weak self] image in
            guard let self = self else { return }
            self.imageView.image = image
            } .catch { error in
                print(error)
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
