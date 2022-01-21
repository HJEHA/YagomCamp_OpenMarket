import UIKit

extension UIImage {
    func compressImage() -> UIImage {
        let compressedSize = self.calculateImageResizingRatio()
        let resizedImage: UIImage?
        
        if #available(iOS 15.0, *) {
            resizedImage = self.preparingThumbnail(of: compressedSize)
        } else {
            resizedImage = self.resizeImageTo(size: compressedSize)
        }
        
        guard let resizedImage = resizedImage else {
            return UIImage()
        }
        
        return resizedImage
    }
    
    func calculateImageResizingRatio(maxSizeInKB: CGFloat = 300) -> CGSize {
        guard let imageDataSize = self.pngData()?.count else {
            return CGSize.zero
        }
        
        let currentImageSize = self.size
        let maxImageSize: CGFloat = maxSizeInKB * 1024
        let resizingRatio = CGFloat(maxImageSize) / CGFloat(imageDataSize)
        
        let newWidth = currentImageSize.width * resizingRatio
        let newHeight = currentImageSize.height * resizingRatio
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
    func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
