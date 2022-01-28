import UIKit

class ProductDetailImageCell: UICollectionViewCell {
    static let identifier = "ProductDetailImageCell"
    
    let productImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupImageViwe()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupImageViwe() {
        addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        productImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func setProductImage(url: String) {
        productImageView.contentMode = .scaleAspectFill
        productImageView.loadImage(of: url)
    }
}
