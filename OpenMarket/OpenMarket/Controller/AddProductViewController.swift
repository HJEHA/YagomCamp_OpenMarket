import UIKit

final class AddProductViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "상품 등록"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupTitleLabel()
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}
