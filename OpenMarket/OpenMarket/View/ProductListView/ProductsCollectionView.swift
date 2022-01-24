import UIKit

final class ProductsCollectionView: UICollectionView {
    var reloadDataCompletionHandler: (() -> Void)?
    
    func setupConstraints(with superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor)
            .isActive = true
        trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor)
            .isActive = true
    }
    
    func reloadDataCompletion(_ completion: @escaping () -> Void) {
        reloadDataCompletionHandler = completion
        super.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let handler = reloadDataCompletionHandler {
            handler()
            reloadDataCompletionHandler = nil
        }
    }
    
    func fadeIn(withDuration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    func fadeOut(withDuration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }, completion: completion)
    }
}
