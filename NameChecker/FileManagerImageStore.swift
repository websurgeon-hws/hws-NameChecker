//
//  Copyright © 2019 Peter Barclay. All rights reserved.
//

import UIKit

public struct FileManagerImageStore: ImageStore {
    private let fileManager: FileManager
    
    public init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func saveImage(_ image: UIImage, withName name: String, compressionQuality: CGFloat = 0.8) -> Result<URL, ImageStoreSaveError> {
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
            return .failure(.failedToGenerateDataFromImage)
        }
        
        guard let url = getDocumentsDirectory()?.appendingPathComponent(name) else {
            return .failure(.storeLocationNotFound)
        }
        
        do {
            try imageData.write(
                to: url,
                options: [
                    .atomicWrite,
                    .completeFileProtection])

            return .success(url)
        } catch {
            return .failure(.unhandled(error: error))
        }
    }
    
    public func loadImage(withName name: String) -> Result<UIImage, ImageStoreLoadError> {
        guard let url = getDocumentsDirectory()?.appendingPathComponent(name) else {
            return .failure(.storeLocationNotFound)
        }

        do {
            let loadedImageData = try Data(contentsOf: url)
            
            guard let image = UIImage(data: loadedImageData) else {
                return .failure(.noImageFound)
            }

            return .success(image)
        } catch {
            return .failure(.unhandled(error: error))
        }
    }
    
    private func getDocumentsDirectory() -> URL? {
        let urls = fileManager.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        return urls.first
    }
}

extension FileManager: ImageStore {
    
    public func saveImage(_ image: UIImage, withName name: String, compressionQuality: CGFloat) -> Result<URL, ImageStoreSaveError> {
        return FileManagerImageStore(fileManager: self)
            .saveImage(image,
                       withName: name,
                       compressionQuality: compressionQuality)
    }

    public func loadImage(withName name: String) -> Result<UIImage, ImageStoreLoadError> {
        return FileManagerImageStore(fileManager: self)
            .loadImage(withName: name)
    }
}
