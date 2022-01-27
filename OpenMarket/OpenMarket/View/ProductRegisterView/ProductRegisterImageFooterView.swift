import UIKit

final class ProductRegisterImageFooterView: UICollectionReusableView {
    static let identifier = "ProductRegisterImageFooterView"
    private(set) var addButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(addButton)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.backgroundColor = .lightGray

        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.3).isActive = true
        addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor).isActive = true
    }
}
