import UIKit

class ProductDetailScrollView: UIScrollView {
    private let verticalStackView = UIStackView()
    private var productDetailImageCollectionView = UICollectionView(frame: CGRect.zero,
                                                                    collectionViewLayout: UICollectionViewFlowLayout())
    private(set) var imageNumberPageControl = UIPageControl()
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
        setPageControl()
        setLabelsStackView()
        setLabels()
        setupDescriptionTextView()
        setupSubviewsAutoresizingMask()
    }
    
    func setupVerticalStackView() {
        addSubview(verticalStackView)
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 10
        verticalStackView.backgroundColor = .systemRed
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
    
    func setPageControl() {
        verticalStackView.addArrangedSubview(imageNumberPageControl)
        imageNumberPageControl.numberOfPages = 5 // todo 밖에서 이미지 개수 설정
        imageNumberPageControl.currentPage = 0
        imageNumberPageControl.pageIndicatorTintColor = .lightGray
        imageNumberPageControl.currentPageIndicatorTintColor = .systemBlue
    }
    
    func setLabelsStackView() {
        let horizontalStackView = UIStackView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        verticalStackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(nameLabel)
        horizontalStackView.backgroundColor = .systemGray
        
        let stockAndPriceStackView = UIStackView()
        stockAndPriceStackView.translatesAutoresizingMaskIntoConstraints = false
        stockAndPriceStackView.axis = .vertical
        stockAndPriceStackView.alignment = .trailing
        stockAndPriceStackView.distribution = .fill
       
        horizontalStackView.addArrangedSubview(stockAndPriceStackView)
        stockAndPriceStackView.addArrangedSubview(stockLabel)
        stockAndPriceStackView.addArrangedSubview(priceLabel)
        stockAndPriceStackView.addArrangedSubview(bargainPriceLabel)
        stockAndPriceStackView.backgroundColor = .systemPink
        stockAndPriceStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func setLabels() {
        nameLabel.text = "제목제목제목제목제목제목제목제목제목제목제목"
        nameLabel.font = .preferredFont(forTextStyle: .body)
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
          
        stockLabel.text = "남은 수량 : 182"
        stockLabel.font = .preferredFont(forTextStyle: .body)
        stockLabel.textAlignment = .right
        stockLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        priceLabel.text = "KRW 20000"
        priceLabel.font = .preferredFont(forTextStyle: .body)
        priceLabel.textAlignment = .right
        
        bargainPriceLabel.text = "KRW 10000"
        bargainPriceLabel.font = .preferredFont(forTextStyle: .body)
        bargainPriceLabel.textAlignment = .right
    }
    
    private func setupDescriptionTextView() {
        verticalStackView.addArrangedSubview(descriptionTextView)
        descriptionTextView.text = ProductPlaceholder.description.text
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.font = .preferredFont(forTextStyle: .body)
        descriptionTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    private func setupSubviewsAutoresizingMask() {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
