import Foundation

protocol ProductCellProtocol: AnyObject {
    var productThumbnailView: UIImageView { get }
    var nameLabel: UILabel { get }
    
    func changePriceAnddiscountedPriceLabel(price: Int, discountedPrice: Int, bargainPrice: Int, currency: Currency)
    func changeStockLabel(by stock: Int)
}
