import UIKit

class GridProductCell: UICollectionViewCell, ProductCellProtocol {
    static let identifier = "GridProductCell"
    
    private let verticalStackView = UIStackView()
    private let productThumbnailView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let bargainPriceLabel = UILabel()
    private let stockLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBorderLine()
        setupStackView()
        setupSubviewsOfVerticalStackView()
        setupThumbnailView()
        setupLabels()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBorderLine() {
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = 10
        layer.borderWidth = 1
    }
    
    private func setupStackView() {
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 8
        
        contentView.addSubview(verticalStackView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStackView.layoutMargins = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        verticalStackView.isLayoutMarginsRelativeArrangement = true
        
        verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            .isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            .isActive = true
        verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
            .isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            .isActive = true
    }
    
    private func setupSubviewsOfVerticalStackView() {
        verticalStackView.addArrangedSubview(productThumbnailView)
        verticalStackView.addArrangedSubview(nameLabel)
        
        let pricesStackView = UIStackView()
        pricesStackView.axis = .vertical
        pricesStackView.alignment = .center
        pricesStackView.distribution = .fillEqually
        pricesStackView.addArrangedSubview(priceLabel)
        pricesStackView.addArrangedSubview(bargainPriceLabel)
        verticalStackView.addArrangedSubview(pricesStackView)
    
        verticalStackView.addArrangedSubview(stockLabel)
    }
    
    private func setupThumbnailView() {
        productThumbnailView.contentMode = .scaleAspectFit
        
        productThumbnailView.widthAnchor.constraint(equalTo: verticalStackView.widthAnchor, multiplier: 0.8)
            .isActive = true
        productThumbnailView.heightAnchor.constraint(equalTo: productThumbnailView.widthAnchor)
            .isActive = true
    }
    
    private func setupLabels() {
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.textAlignment = .center
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        priceLabel.font = .preferredFont(forTextStyle: .body)
        priceLabel.textAlignment = .center
        
        bargainPriceLabel.font = .preferredFont(forTextStyle: .body)
        bargainPriceLabel.textAlignment = .center
        bargainPriceLabel.textColor = .lightGray
        
        stockLabel.font = .preferredFont(forTextStyle: .body)
        stockLabel.textAlignment = .center
        stockLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
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
    
    private func changePriceAndDiscountedPriceLabel(price: Int,
                                                    discountedPrice: Int,
                                                    bargainPrice: Int,
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
