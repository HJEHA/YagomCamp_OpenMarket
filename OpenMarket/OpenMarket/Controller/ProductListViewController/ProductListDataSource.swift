import UIKit

protocol ProductListDataSourceDelegate: AnyObject {
    func productListDataSourceDidChangeLayout()
    func productListDataSourceDidSetupProducts()
    func productListDataSourceDidCheckNewProduct()
}

final class ProductListDataSource: NSObject {
    // MARK: - Properties
    enum LayoutKind: String, CaseIterable, CustomStringConvertible {
        case list = "LIST"
        case grid = "GRID"
        
        var description: String {
            return self.rawValue
        }
        
        var cellIdentifier: String {
            switch self {
            case .list:
                return ListProductCell.identifier
            case .grid:
                return GridProductCell.identifier
            }
        }
        
        var cellType: ProductCellProtocol.Type {
            switch self {
            case .list:
                return ListProductCell.self
            case .grid:
                return GridProductCell.self
            }
        }
    }
    
    weak var delegate: ProductListDataSourceDelegate?
    
    private(set) var currentLayoutKind: LayoutKind = .list
    private var products: [Product]?
    private var currentProductID: Int = 0
    
    // MARK: - Methods
    override init() {
        super.init()
        setupProducts()
        autoCheckNewProduct()
    }
    
    func setupProducts() {
        NetworkDataTransfer().fetchData(api: ProductPageAPI(pageNumber: 1, itemsPerPage: 100),
                                        decodingType: ProductPage.self) { [weak self] data in
            let firstIndex = 0
            self?.products = data.products
            self?.currentProductID = data.products[firstIndex].id
            self?.delegate?.productListDataSourceDidSetupProducts()
        }
    }
    
    private func autoCheckNewProduct(timeInterval: TimeInterval = 10) {
        Timer.scheduledTimer(timeInterval: timeInterval,
                             target: self,
                             selector: #selector(checkNewProduct),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc private func checkNewProduct() {
        NetworkDataTransfer().fetchData(api: ProductPageAPI(pageNumber: 1, itemsPerPage: 100),
                                        decodingType: ProductPage.self) { [weak self] data in
            let firstIndex = 0
            let latestProductID = data.products[firstIndex].id
            if latestProductID != self?.currentProductID {
                self?.delegate?.productListDataSourceDidCheckNewProduct()
            }
        }
    }
    
    func changeLayoutKind(at index: Int) {
        currentLayoutKind = LayoutKind.allCases[index]
        delegate?.productListDataSourceDidChangeLayout()
    }
}

// MARK: - CollectionView DataSource
extension ProductListDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                           withReuseIdentifier: currentLayoutKind.cellIdentifier,
                           for: indexPath
                         ) as? ProductCellProtocol else {
            return UICollectionViewCell()
        }
        
        guard let product = products?[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        cell.updateView(with: product)
        
        return cell
    }
}
