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
        let underLinePositionX: CGFloat = 10
        let underLine = layer.addBorder([.bottom], color: UIColor.systemGray, width: 0.5)
        underLine.frame = CGRect(x: underLinePositionX,
                                 y: layer.frame.height,
                                 width: underLine.frame.width - underLinePositionX,
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
        
        horizontalStackView.layoutMargins = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
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
        pricesStackView.distribution = .fillEqually
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
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        priceLabel.font = .preferredFont(forTextStyle: .body)
        priceLabel.textAlignment = .center
        
        bargainPriceLabel.font = .preferredFont(forTextStyle: .body)
        bargainPriceLabel.textAlignment = .center
        bargainPriceLabel.textColor = .lightGray
        
        stockLabel.font = .preferredFont(forTextStyle: .body)
        stockLabel.textAlignment = .right
        stockLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stockLabel.numberOfLines = 0
    }
    
    func updateView(with data: Product) {
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
            priceLabel.attributedText = "\(currency.rawValue) \(price.formattedWithComma())".strikeThrough()
            priceLabel.textColor = .systemRed
            
            bargainPriceLabel.isHidden = false
            bargainPriceLabel.text = "\(currency.rawValue) \(bargainPrice.formattedWithComma())"
        }
    }
    
    private func changeStockLabel(by stock: Int) {
        if stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        } else {
            stockLabel.text = "잔여수량 : \(stock.formattedWithComma())"
            stockLabel.textColor = .systemGray
        }
    }
}
