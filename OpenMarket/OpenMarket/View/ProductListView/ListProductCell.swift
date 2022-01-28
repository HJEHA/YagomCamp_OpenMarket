import UIKit

final class ListProductCell: UICollectionViewCell, ProductCellProtocol {
    static let identifier = "ListProductCell"
    
    private let horizontalStackView = UIStackView()
    private let productThumbnailView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let bargainPriceLabel = UILabel()
    private let stockLabel = UILabel()
    private let accessoryImageView = UIImageView()
    
    private(set) var productId: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUnderLine()
        setupStackView()
        setupSubviewsOfHorizontalStackView()
        setupThumbnailView()
        setupAccessoryImageView()
        setupLabels()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUnderLine() {
        let inset: CGFloat = 10
        let underLine = layer.addBorder([.bottom], color: UIColor.systemGray, width: 0.5)
        underLine.frame = CGRect(x: 0,
                                 y: layer.frame.height,
                                 width: underLine.frame.width + inset,
                                 height: underLine.frame.height)
        layer.addSublayer(underLine)
    }
    
    private func setupStackView() {
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .top
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 8
        
        contentView.addSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let sideInset: Double = 0
        let topBottomInset: Double = 10
        horizontalStackView.layoutMargins = UIEdgeInsets(top: topBottomInset,
                                                         left: sideInset,
                                                         bottom: topBottomInset,
                                                         right: sideInset)
        horizontalStackView.isLayoutMarginsRelativeArrangement = true
        
        horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            .isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            .isActive = true
        horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
            .isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            .isActive = true
    }
    
    private func setupSubviewsOfHorizontalStackView() {
        horizontalStackView.addArrangedSubview(productThumbnailView)
        
        let nameAndStockStackView = UIStackView()
        nameAndStockStackView.axis = .horizontal
        nameAndStockStackView.alignment = .center
        nameAndStockStackView.distribution = .fill
        nameAndStockStackView.spacing = 4
        nameAndStockStackView.addArrangedSubview(nameLabel)
        nameAndStockStackView.addArrangedSubview(stockLabel)
        nameAndStockStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let pricesStackView = UIStackView()
        pricesStackView.axis = .horizontal
        pricesStackView.alignment = .center
        pricesStackView.distribution = .fill
        pricesStackView.spacing = 4
        pricesStackView.addArrangedSubview(priceLabel)
        pricesStackView.addArrangedSubview(bargainPriceLabel)
    
        let nameAndPricesStackView = UIStackView()
        nameAndPricesStackView.axis = .vertical
        nameAndPricesStackView.alignment = .leading
        nameAndPricesStackView.distribution = .fillEqually
        nameAndPricesStackView.addArrangedSubview(nameAndStockStackView)
        nameAndPricesStackView.addArrangedSubview(pricesStackView)
        nameAndPricesStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        nameAndStockStackView.widthAnchor.constraint(equalTo: nameAndPricesStackView.widthAnchor)
            .isActive = true
        horizontalStackView.addArrangedSubview(nameAndPricesStackView)
        horizontalStackView.addArrangedSubview(accessoryImageView)
        
        nameAndPricesStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            .isActive = true
    }
    
    private func setupThumbnailView() {
        productThumbnailView.contentMode = .scaleAspectFit
        productThumbnailView.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        productThumbnailView.widthAnchor.constraint(equalTo: horizontalStackView.heightAnchor, multiplier: 0.8)
            .isActive = true
    }
    
    private func setupAccessoryImageView() {
        accessoryImageView.image = UIImage(systemName: "chevron.right")
        accessoryImageView.tintColor = .systemGray
        accessoryImageView.contentMode = .scaleAspectFit
        
        accessoryImageView.widthAnchor.constraint(equalTo: stockLabel.heightAnchor)
            .isActive = true
        accessoryImageView.heightAnchor.constraint(equalTo: accessoryImageView.widthAnchor)
            .isActive = true
    }
    
    private func setupLabels() {
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.textAlignment = .center
        nameLabel.setContentHuggingPriority(.required, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        priceLabel.font = .preferredFont(forTextStyle: .body)
        priceLabel.textAlignment = .center
        
        bargainPriceLabel.font = .preferredFont(forTextStyle: .body)
        bargainPriceLabel.textAlignment = .center
        bargainPriceLabel.textColor = .lightGray
        
        stockLabel.font = .preferredFont(forTextStyle: .body)
        stockLabel.textAlignment = .right
        stockLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stockLabel.numberOfLines = 0
        stockLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    func applyData(_ data: Product) {
        setProductId(with: data)
        updateView(with: data)
    }
    
    private func setProductId(with data: Product) {
        productId = data.id
    }
    
    private func updateView(with data: Product) {
        productThumbnailView.loadImage(of: data.thumbnail)
        nameLabel.text = data.name
        changePriceAndDiscountedPriceLabel(price: data.price,
                                           discountedPrice: data.discountedPrice,
                                           bargainPrice: data.bargainPrice,
                                           currency: data.currency)
        changeStockLabel(by: data.stock)
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
}
