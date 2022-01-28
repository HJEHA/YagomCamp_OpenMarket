import Foundation

protocol ProductDetailDataSourceDelegate: AnyObject {
    func productDetailDataSource(didFetchProduct product: DetailViewProduct?)
}

final class ProductDetailDataSource: NSObject {
    // MARK: - Properties
    weak var delegate: ProductDetailDataSourceDelegate?
    var productDetail: DetailViewProduct?
    
    func setupProducts(at productId: Int?) {
        guard let productId = productId else {
            return
        }
        
        NetworkDataTransfer().fetchData(api: ProductDetailAPI(id: productId),
                                        decodingType: DetailViewProduct.self) { [weak self] data in
            self?.productDetail = data
            self?.delegate?.productDetailDataSource(didFetchProduct: self?.productDetail)
        }
    }
}
