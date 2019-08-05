import UIKit
import PromiseKit

class ImageService {
    
    private var images = [String: UIImage]()
    private let cacheLifeTime: TimeInterval = 60 * 60 * 24 * 7
    
    private static let pathName: String = {
        let pathName = "images"
        
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cacheDir.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private func getFilePath(urlString: String) -> String? {
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
            let filename = urlString.split(separator: "/").last else { return nil }
        
//        let hashName = String(describing: urlString.hashValue)
        
        return cacheDir.appendingPathComponent(ImageService.pathName + "/" + filename).path
    }
    
    private func saveImageToCache(urlString: String, image: UIImage) {
        guard let filename = getFilePath(urlString: urlString) else { return }
        
        let data = image.pngData()
        FileManager.default.createFile(atPath: filename, contents: data, attributes: nil)
    }
    
    private func getImageFromCache(urlString: String) -> UIImage? {
        guard let filename = getFilePath(urlString: urlString),
            let info = try? FileManager.default.attributesOfItem(atPath: filename),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return nil }
        
        let lefttime = Date().timeIntervalSince(modificationDate)
        guard lefttime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: filename) else { return nil }
        
        DispatchQueue.main.async {
            self.images[urlString] = image
        }
        
        return image
    }
    
    private func loadPhoto(with urlString: String) -> Promise<UIImage> {
        guard let request = URL(string: urlString) else {
            return Promise(error: PMKError.badInput)
        }
        
        return URLSession.shared.dataTask(.promise, with: request)
            .map({ [weak self] data, response in
                guard let self = self,
                    let newImage = UIImage(data: data) else {
                        throw PMKError.badInput
                }
                
                DispatchQueue.main.async {
                    self.images[urlString] = newImage
                }
                
                self.saveImageToCache(urlString: urlString, image: newImage)
                return newImage
            })
    }
    
    public func photo(with urlString: String) -> Promise<UIImage> {
        
        return Promise<UIImage> { resolver in
            if let image = images[urlString] {
                resolver.fulfill(image)
            } else if let image = getImageFromCache(urlString: urlString) {
                resolver.fulfill(image)
            } else {
                loadPhoto(with: urlString).done({ image in
                    resolver.fulfill(image)
                }).catch({ error in
                    resolver.reject(error)
                })
            }
        }
    }
}

