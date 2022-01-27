import UIKit

final class ProductListLayout: NSObject {
    private unowned var dataSource: ProductListDataSource
    
    init(dataSource: ProductListDataSource) {
        self.dataSource = dataSource
    }
}

// MARK: - CollectionView Delegate FlowLayout
extension ProductListLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch dataSource.currentLayoutKind {
        case .list:
            let inset: Double = 10
            let cellHeightRatio = 0.077
            let listCellSize: (width: CGFloat, height: CGFloat) = (UIScreen.main.bounds.width - inset * 2,
                                                                   UIScreen.main.bounds.height * cellHeightRatio)
            return CGSize(width: listCellSize.width, height: listCellSize.height)
        case .grid:
            let cellWidthRatio = 0.45
            let cellHeightRatio = 0.32
            let gridCellSize: (width: CGFloat, height: CGFloat) = (UIScreen.main.bounds.width * cellWidthRatio,
                                                                   UIScreen.main.bounds.height * cellHeightRatio)
            
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
        if let refreshControl = scrollView.refreshControl,
           refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}
