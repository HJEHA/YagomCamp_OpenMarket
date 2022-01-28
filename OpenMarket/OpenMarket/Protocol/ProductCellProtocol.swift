import UIKit

protocol ProductCellProtocol: UICollectionViewCell {
    var productId: Int { get }
    
    func applyData(_ data: Product)
}
