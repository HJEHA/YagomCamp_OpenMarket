import UIKit

final class AddProductViewController: UIViewController {
    private let productManagementView = ProductManagementView()
    private var imageCollectionView: UICollectionView!
    private var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
        
        view.addSubview(productManagementView)
        productManagementView.setupConstraints(with: view)
        productManagementView.setupSubviews()
        
        setupImageCollectionView()
        setupDescriptionTextView()
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
        title = "상품등록"
    }
    
    private func setupImageCollectionView() {
        imageCollectionView = productManagementView.imageCollectionView
        imageCollectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.identifier)
        imageCollectionView.dataSource = self
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView = productManagementView.descriptionTextView
        descriptionTextView.delegate = self
    }
}

// MARK: - NavigationBar, Segmented Control
extension AddProductViewController {
    private func setupNavigationBar() {
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

// MARK: - ImageCollectionViwe DataSource
extension AddProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.identifier,
                                                            for: indexPath) as? ProductImageCell else {
            return UICollectionViewCell()
        }
        
        let image = UIImage(systemName: "xmark.circle.fill")
        cell.setupProductImage(with: image)
        
        return cell
    }
}

// MARK: - TextView Delegate
extension AddProductViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {  
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = ProductPlaceholder.description.text
            textView.textColor = UIColor.lightGray
        }
    }
}
