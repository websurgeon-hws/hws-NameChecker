//
//  Copyright © 2019 Peter Barclay. All rights reserved.
//

import UIKit

public enum ImageStoreSaveError: Error {
    case noImageFound
    case failedToGenerateDataFromImage
    case storeLocationNotFound
    case unhandled(error: Error)
}

public enum ImageStoreLoadError: Error {
    case storeLocationNotFound
    case noImageFound
    case unhandled(error: Error)
}

public protocol ImageStore {
    func saveImage(
        _ image: UIImage,
        withName name: String,
        compressionQuality: CGFloat
    ) -> Result<URL, ImageStoreSaveError>
    
    func loadImage(withName name: String) -> Result<UIImage, ImageStoreLoadError>
}
