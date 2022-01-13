import UIKit

class AddProductViewController: UIViewController {
    var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupTitleLabel()
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "상품 등록"
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.textAlignment = .center
    }
}
