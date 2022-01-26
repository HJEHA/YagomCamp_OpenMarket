import UIKit

class ProductListStackView: UIStackView {
    private(set) var listRefreshButton = UIButton()
    private(set) var productCollectionView: ProductsCollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupRefreshButton()
        setupProductCollectionView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        axis = .vertical
    }
    
    func setupConstraints(with superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor)
            .isActive = true
        trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor)
            .isActive = true
    }
    
    private func setupRefreshButton() {
        addArrangedSubview(listRefreshButton)
        listRefreshButton.titleLabel?.numberOfLines = 0
        listRefreshButton.backgroundColor = .lightGray
        listRefreshButton.setTitle("새로운 상품이 추가 되었습니다.\n아래로 스크롤하거나 여기을 눌러주세요.", for: .normal)
        listRefreshButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
        
        listRefreshButton.translatesAutoresizingMaskIntoConstraints = false
        listRefreshButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        listRefreshButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        listRefreshButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        listRefreshButton.isHidden = true
    }
    
    private func setupProductCollectionView() {
        productCollectionView = ProductsCollectionView(frame: self.frame,
                                                       collectionViewLayout: UICollectionViewFlowLayout())
        addArrangedSubview(productCollectionView)
        productCollectionView.setupConstraints(with: self)
    }
    
    func showRefreshButton() {
        let firstIndex = 0
        listRefreshButton.isHidden = false
        insertArrangedSubview(listRefreshButton, at: firstIndex)
    }
    
    func hideRefreshButton() {
        listRefreshButton.removeFromSuperview()
    }
}
