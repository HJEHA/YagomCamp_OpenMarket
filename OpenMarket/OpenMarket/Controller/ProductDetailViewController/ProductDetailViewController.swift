import UIKit

class ProductDetailViewController: UIViewController {
    
    private let dataSource = ProductDetailDataSource()
    let productDetailScrollView = ProductDetailScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
        setupProductDetailScrollView()
        dataSource.delegate = self
        dataSource.setupProducts(at: 1000)
    }
    
    func setup() {
        view.backgroundColor = .white
    }
    
    func setupProductDetailScrollView() {
        view.addSubview(productDetailScrollView)
        productDetailScrollView.setupConstraints(with: view)
        productDetailScrollView.setupSubviews()
    }
}

// MARK: - NavigationBar
extension ProductDetailViewController {
    private func setupNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", // 목록화면에서 navi로 이동하도록 연결
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(touchUpActionButton))
    }
    
    @objc private func touchUpActionButton() {
        let editButton = UIAlertAction(title: "수정", style: .default, handler: nil) // 수정화면 연결
        let deleteButton = UIAlertAction(title: "삭제", style: .destructive, handler: nil) // Alert의 TextField에 비밀번호 입력
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        
        let alert = AlertFactory().createAlert(style: .actionSheet,
                                               actions: editButton, deleteButton, cancelButton)
        
        present(alert, animated: true)
    }
}

extension ProductDetailViewController: ProductDetailDataSourceDelegate {
    func productDetailDataSource(didFetchProduct product: DetailViewProduct?) {
        if let product = product {
            DispatchQueue.main.async { [weak self] in
                self?.productDetailScrollView.updateView(with: product)
            }
        }
    }
}
