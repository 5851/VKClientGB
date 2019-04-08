import UIKit

class Friend {
    let name: String
    let iconImage: UIImage?
    let photos: [UIImage?]

    init(name: String, iconImage: UIImage?, photos: [UIImage?]) {
        self.name = name
        self.iconImage = iconImage
        self.photos = photos
    }
}
