import UIKit

protocol ProductCellProtocol: UICollectionViewCell {
    func updateView(with data: Product)
}
