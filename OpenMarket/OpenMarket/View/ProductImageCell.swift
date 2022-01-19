import UIKit

final class ProductImageCell: UICollectionViewCell {
    static let identifier = "ProductImageCell"
    
    private let imageView = UIImageView()
    let removeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(imageView)
        contentView.addSubview(removeButton)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            .isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            .isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
            .isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            .isActive = true
        
        removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            .isActive = true
        removeButton.topAnchor.constraint(equalTo: contentView.topAnchor)
            .isActive = true
    }
    
    private func setupButton() {
        let image = UIImage(systemName: "xmark.circle.fill")
        removeButton.setImage(image, for: .normal)
    }
    
    func setupProductImage(with image: UIImage?) {
        imageView.image = image
    }
}
