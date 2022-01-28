import Foundation
import UIKit

protocol ProductDetailDataSourceDelegate: AnyObject {
    func productDetailDataSource(didFetchProduct product: DetailViewProduct?)
}

final class ProductDetailDataSource: NSObject {
    // MARK: - Properties
    weak var delegate: ProductDetailDataSourceDelegate?
    var productDetail: DetailViewProduct?
    
    // MARK: - Methods
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

// MARK: - CollectionView DataSource
extension ProductDetailDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDetail?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductDetailImageCell.identifier,
                                                            for: indexPath) as? ProductDetailImageCell else {
            return UICollectionViewCell()
        }
        
        guard let productDetail = productDetail else {
            return UICollectionViewCell()
        }
        
        let imageURL = productDetail.images[indexPath.item].url
        cell.setProductImage(url: imageURL)
        
        return cell
    }
}
