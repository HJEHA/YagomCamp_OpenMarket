import UIKit


protocol OpenMarketDataSourceDelegate: AnyObject {
    func openMarketDataSourceDidChangeLayout()
    func openMarketDataSourceDidSetupProducts()
    func openMarketDataSourceDidCheckNewProduct()
}

final class OpenMarketDataSource: NSObject {
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
    
    override init() {
        super.init()
        setupProducts()
        autoCheckNewProduct()
    }
    
    weak var delegate: OpenMarketDataSourceDelegate?
    
    var currentLayoutKind: LayoutKind = .list
    var products: [Product]?
    var currentProductID: Int = 0
    
    func changeLayoutKind(at index: Int) {
        currentLayoutKind = LayoutKind.allCases[index]
        delegate?.openMarketDataSourceDidChangeLayout()
    }
    
    func setupProducts() {
        NetworkDataTransfer().fetchData(api: ProductPageAPI(pageNumber: 1, itemsPerPage: 100),
                                        decodingType: ProductPage.self) { [weak self] data in
            let firstIndex = 0
            self?.products = data.products
            self?.currentProductID = data.products[firstIndex].id
            self?.delegate?.openMarketDataSourceDidSetupProducts()
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
                self?.delegate?.openMarketDataSourceDidCheckNewProduct()
            }
        }
    }
}

// MARK: - CollectionView Data Source
extension OpenMarketDataSource: UICollectionViewDataSource {
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

// MARK: - CollectionView Delegate FlowLayout
extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch dataSource.currentLayoutKind {
        case .list:
            let inset: Double = 10
            let cellHeightRatio = 0.077
            let listCellSize: (width: CGFloat, height: CGFloat) = (view.frame.width - inset * 2,
                                                                   view.frame.height * cellHeightRatio)
            return CGSize(width: listCellSize.width, height: listCellSize.height)
        case .grid:
            let cellWidthRatio = 0.45
            let cellHeightRatio = 0.32
            let gridCellSize: (width: CGFloat, height: CGFloat) = (view.frame.width * cellWidthRatio,
                                                                   view.frame.height * cellHeightRatio)
            
            return CGSize(width: gridCellSize.width, height: gridCellSize.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: Double = 10
        
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch dataSource.currentLayoutKind {
        case .list:
            let listCellLineSpacing: CGFloat = 2
            
            return listCellLineSpacing
        case .grid:
            let gridCellLineSpacing: CGFloat = 10
            
            return gridCellLineSpacing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch dataSource.currentLayoutKind {
        case .list:
            let listCellIteritemSpacing: CGFloat = 0
            
            return listCellIteritemSpacing
        case .grid:
            let gridCellIteritemSpacing: CGFloat = 10
            
            return gridCellIteritemSpacing
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}
