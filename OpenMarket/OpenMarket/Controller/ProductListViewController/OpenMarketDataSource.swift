import UIKit

final class OpenMarketDataSource {
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
    
    var currentLayoutKind: LayoutKind = .list
    var products: [Product]?
    var currentProductID: Int = 0
}

// MARK: - SegmentControl
extension OpenMarketViewController {
    @objc func toggleViewTypeSegmentedControl(_ sender: UISegmentedControl) {
        let currentScrollRatio: CGFloat = currentScrollRatio()
        dataSource.currentLayoutKind = OpenMarketDataSource.LayoutKind.allCases[sender.selectedSegmentIndex]
        
        productCollectionView.fadeOut { _ in
            self.productCollectionView.reloadDataCompletion { [weak self] in
                self?.syncScrollIndicator(with: currentScrollRatio)
                self?.productCollectionView.fadeIn()
            }
        }
    }
    
    private func currentScrollRatio() -> CGFloat {
        return productCollectionView.contentOffset.y / productCollectionView.contentSize.height
    }
    
    private func syncScrollIndicator(with currentScrollRatio: CGFloat) {
        let nextViewMaxHeight = productCollectionView.contentSize.height
        let offset = CGPoint(x: 0, y: nextViewMaxHeight * currentScrollRatio)
        productCollectionView.setContentOffset(offset, animated: false)
    }
}

// MARK: - CollectionView Data Source
extension OpenMarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dataSource.products?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                           withReuseIdentifier: dataSource.currentLayoutKind.cellIdentifier,
                           for: indexPath
                         ) as? ProductCellProtocol else {
            return UICollectionViewCell()
        }
        
        guard let product = dataSource.products?[indexPath.item] else {
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
