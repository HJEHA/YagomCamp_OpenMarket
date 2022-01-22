import UIKit

final class ProductImageCell: UICollectionViewCell {
    static let identifier = "ProductImageCell"
    
    private let imageView = UIImageView()
    private(set) var editButton = UIButton()
    private(set) var removeButton = UIButton()
    private(set) var indexPath: IndexPath?
    
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
        contentView.addSubview(editButton)
        contentView.addSubview(removeButton)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            .isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            .isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
            .isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            .isActive = true
        
        editButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            .isActive = true
        editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            .isActive = true
        editButton.topAnchor.constraint(equalTo: contentView.topAnchor)
            .isActive = true
        editButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            .isActive = true
        
        removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10)
            .isActive = true
        removeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -10)
            .isActive = true
        removeButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
    }
    
    private func setupButton() {
        let image = UIImage(systemName: "minus.circle.fill")
        removeButton.setImage(image, for: .normal)
        removeButton.backgroundColor = .white
        removeButton.layer.cornerRadius = 13
        removeButton.tintColor = .systemRed
    }
    
    func setupProductImage(with image: UIImage?) {
        imageView.image = image
    }
    
    func setIndexPath(at indexPath: IndexPath) {
        self.indexPath = indexPath
    }
}
