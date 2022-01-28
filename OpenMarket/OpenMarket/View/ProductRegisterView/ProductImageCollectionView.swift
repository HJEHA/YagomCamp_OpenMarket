import UIKit

class ProductImageCollectionView: UICollectionView {
    var reloadDataCompletionHandler: (() -> Void)?
    
    func setupConstraints(with superview: UIView) { // ToDo: 호출하도록 수정
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor)
            .isActive = true
        trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor)
            .isActive = true
        topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor)
            .isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor)
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
}
