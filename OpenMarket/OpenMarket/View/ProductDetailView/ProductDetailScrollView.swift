import UIKit

class ProductDetailScrollView: UIScrollView {
    private let verticalStackView = UIStackView()
    private(set) var productDetailImageCollectionView = UICollectionView(frame: CGRect.zero,
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
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 30,
                                     height: UIScreen.main.bounds.width  - 30)
        productDetailImageCollectionView.collectionViewLayout = flowLayout
        productDetailImageCollectionView.isPagingEnabled = true
        productDetailImageCollectionView.heightAnchor.constraint(equalTo: productDetailImageCollectionView.widthAnchor)
            .isActive = true
    }
    
    func setPageControl() {
        verticalStackView.addArrangedSubview(imageNumberPageControl)
        imageNumberPageControl.currentPage = 0
        imageNumberPageControl.pageIndicatorTintColor = .lightGray
        imageNumberPageControl.currentPageIndicatorTintColor = .systemBlue
    }
    
    func setLabelsStackView() {
        let horizontalStackView = UIStackView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        horizontalStackView.alignment = .top
        horizontalStackView.spacing = 8
        verticalStackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(nameLabel)
        
        let stockAndPriceStackView = UIStackView()
        stockAndPriceStackView.translatesAutoresizingMaskIntoConstraints = false
        stockAndPriceStackView.axis = .vertical
        stockAndPriceStackView.alignment = .trailing
        stockAndPriceStackView.distribution = .fill
       
        horizontalStackView.addArrangedSubview(stockAndPriceStackView)
        stockAndPriceStackView.addArrangedSubview(stockLabel)
        stockAndPriceStackView.addArrangedSubview(priceLabel)
        stockAndPriceStackView.addArrangedSubview(bargainPriceLabel)
        stockAndPriceStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func setLabels() {
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
          
        stockLabel.font = .preferredFont(forTextStyle: .body)
        stockLabel.textAlignment = .right
        stockLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        priceLabel.font = .preferredFont(forTextStyle: .body)
        priceLabel.textAlignment = .right
        
        bargainPriceLabel.font = .preferredFont(forTextStyle: .body)
        bargainPriceLabel.textAlignment = .right
    }
    
    private func setupDescriptionTextView() {
        verticalStackView.addArrangedSubview(descriptionTextView)
        descriptionTextView.text = ProductPlaceholder.description.text
        descriptionTextView.textColor = .black
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
    
    func updateView(with data: DetailViewProduct) {
        imageNumberPageControl.numberOfPages = data.images.count
        
        nameLabel.text = data.name
        changePriceAndDiscountedPriceLabel(price: data.price,
                                           discountedPrice: data.discountedPrice,
                                           bargainPrice: data.bargainPrice,
                                           currency: data.currency)
        changeStockLabel(by: data.stock)
        changeDescriptionTextView(with: data.description)
    }
    
    private func changePriceAndDiscountedPriceLabel(price: Double,
                                                    discountedPrice: Double,
                                                    bargainPrice: Double,
                                                    currency: Currency) {
        if discountedPrice == 0 {
            priceLabel.attributedText = nil
            priceLabel.textColor = .systemGray
            priceLabel.text = "\(currency.rawValue) \(price.formattedWithComma())"
            
            bargainPriceLabel.isHidden = true
        } else {
            let priceText = "\(currency.rawValue) \(price.formattedWithComma())"
            priceLabel.strikeThrough(text: priceText)
            priceLabel.textColor = .systemRed
            
            bargainPriceLabel.isHidden = false
            bargainPriceLabel.text = "\(currency.rawValue) \(bargainPrice.formattedWithComma())"
        }
    }
    
    private func changeStockLabel(by stock: Int) {
        if stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
            stockLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        } else {
            stockLabel.text = "잔여수량 : \(stock.formattedWithComma())"
            stockLabel.textColor = .systemGray
            stockLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
    }
    
    private func changeDescriptionTextView(with text: String) {
        descriptionTextView.text = text
    }
}
