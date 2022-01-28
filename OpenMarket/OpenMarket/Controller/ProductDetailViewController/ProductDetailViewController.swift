import UIKit

class ProductDetailViewController: UIViewController {
    private let dataSource = ProductDetailDataSource()
    let productDetailScrollView = ProductDetailScrollView()
    
    private var productId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
        setupProductDetailScrollView()
        dataSource.delegate = self
        dataSource.setupProducts(at: productId)
    }
    
    func setProductId(_ productId: Int) {
        self.productId = productId
    }
    
    private func setup() {
        view.backgroundColor = .white
    }
    
    private func setupProductDetailScrollView() {
        view.addSubview(productDetailScrollView)
        productDetailScrollView.setupConstraints(with: view)
        productDetailScrollView.setupSubviews()
    }
}

// MARK: - NavigationBar
extension ProductDetailViewController {
    private func setupNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
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
                self?.title = product.name  // Todo: 개선 필요
            }
        }
    }
}
