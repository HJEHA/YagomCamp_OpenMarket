import UIKit

final class AddProductViewController: UIViewController {
    private var productManagementView = ProductManagementView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
        
        view.addSubview(productManagementView)
        productManagementView.setupConstraints(with: view)
        productManagementView.setupSubviews()
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
        title = "상품등록"
    }
}

// MARK: - NavigationBar, Segmented Control
extension AddProductViewController {
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self,
                                                                action: #selector(touchUpCancelButton))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                target: self,
                                                                action: #selector(touchUpDoneButton))
    }
    
    @objc private func touchUpCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func touchUpDoneButton() {
        navigationController?.popViewController(animated: true)
    }
}
