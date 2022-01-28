import UIKit

class ProductDetailScrollView: UIScrollView {
    private let verticalStackView = UIStackView()
    private var productDetailImageCollectionView = UICollectionView(frame: CGRect.zero,
                                                                    collectionViewLayout: UICollectionViewFlowLayout())
    private let imageNumberPageControl = UIPageControl()
    private let nameLabel = UILabel()
    private let stockLabel = UILabel()
    private let bargainPriceLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionTextView = UITextView()
    
    func setupConstraints(with superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor)
            .isActive = true
        trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor)
            .isActive = true
        topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor)
            .isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            .isActive = true
        widthAnchor.constraint(equalToConstant: superview.frame.width).isActive = true
    }
    
    func setupSubviews() {
        setupVerticalStackView()
        setupProductDetailImageCollectionView()
        
        setupSubviewsAutoresizingMask()
    }
    
    func setupVerticalStackView() {
        addSubview(verticalStackView)
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 10
        verticalStackView.backgroundColor = .systemBlue
        let inset: CGFloat = 15
        verticalStackView.layoutMargins = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        verticalStackView.isLayoutMarginsRelativeArrangement = true
        
        verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        verticalStackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    func setupProductDetailImageCollectionView() {
        verticalStackView.addArrangedSubview(productDetailImageCollectionView)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width,
                                     height: UIScreen.main.bounds.width)
        productDetailImageCollectionView.collectionViewLayout = flowLayout

        productDetailImageCollectionView.heightAnchor.constraint(equalTo: productDetailImageCollectionView.widthAnchor)
            .isActive = true
    }
    
    private func setupSubviewsAutoresizingMask() {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
