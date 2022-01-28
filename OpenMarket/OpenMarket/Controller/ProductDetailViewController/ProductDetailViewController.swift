import UIKit

class ProductDetailViewController: UIViewController {
    // MARK: - Properties
    private let dataSource = ProductDetailDataSource()
    let productDetailScrollView = ProductDetailScrollView()
    private(set) var imageCollectionView: UICollectionView!
    
    private var productId: Int?
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
        setupProductDetailScrollView()
        setupImageCollectionView()
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
    
    private func setupImageCollectionView() {
        imageCollectionView = productDetailScrollView.productDetailImageCollectionView
        imageCollectionView.register(ProductDetailImageCell.self,
                                     forCellWithReuseIdentifier: ProductDetailImageCell.identifier)
        imageCollectionView.dataSource = dataSource
        imageCollectionView.delegate = self
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

// MARK: - Product Detail DataSource Delegate
extension ProductDetailViewController: ProductDetailDataSourceDelegate {
    func productDetailDataSource(didFetchProduct product: DetailViewProduct?) {
        if let product = product {
            DispatchQueue.main.async { [weak self] in
                self?.productDetailScrollView.updateView(with: product)
                self?.imageCollectionView.reloadData()
                self?.title = product.name  // Todo: 개선 필요
            }
        }
    }
}

// MARK: - CollectionView Delegate
extension ProductDetailViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let sideInset: CGFloat = 30
        let page = Int(targetContentOffset.pointee.x / (view.frame.width - sideInset))
        productDetailScrollView.imageNumberPageControl.currentPage = page
      }
}
