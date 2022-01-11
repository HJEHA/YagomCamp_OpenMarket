import UIKit

class GridProductCell: UICollectionViewCell {
    static let identifier = "GridProductCell"  
    
    let verticalStackView = UIStackView()
    let productThumbnailView = UIImageView()
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let bargainPriceLabel = UILabel()
    let stockLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStackView()
        setupLabels()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.distribution = .fillEqually
        
        contentView.addSubview(verticalStackView)
        verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        verticalStackView.addArrangedSubview(productThumbnailView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(priceLabel)
        verticalStackView.addArrangedSubview(bargainPriceLabel)
        verticalStackView.addArrangedSubview(stockLabel)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        productThumbnailView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        bargainPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLabels() {
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.textAlignment = .center
        
        priceLabel.font = .preferredFont(forTextStyle: .body)
        priceLabel.textColor = .lightGray
        priceLabel.textAlignment = .center
        
        bargainPriceLabel.font = .preferredFont(forTextStyle: .body)
        bargainPriceLabel.textColor = .lightGray
        bargainPriceLabel.textAlignment = .center
        
        stockLabel.font = .preferredFont(forTextStyle: .body)
        stockLabel.textColor = .lightGray
        stockLabel.textAlignment = .center
    }
    
    func changeSoldOutStockLabel() {
        stockLabel.text = "품절"
        stockLabel.textColor = .systemYellow
    }

    func strikePriceLabel(text: String) {
        priceLabel.attributedText = text.strikeThrough()
        priceLabel.textColor = .systemRed
    }
}
