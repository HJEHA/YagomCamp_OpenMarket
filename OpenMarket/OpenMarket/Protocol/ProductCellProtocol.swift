import UIKit

protocol ProductCellProtocol: UICollectionViewCell {
    func updateLabels(with data: Product)
    func updateThumbnailView(with image: UIImage?)
}
