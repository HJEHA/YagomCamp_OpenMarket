import UIKit

enum ViewTitle: String {
    case productRegister = "상품등록"
    
    fileprivate var description: String {
        return self.rawValue
    }
}

final class AddProductViewController: UIViewController {
    // MARK: - Properties
    private(set) var productManagementScrollView = ProductManagementScrollView()
    private(set) var imageCollectionView: ProductImageCollectionView!
    private var descriptionTextView: UITextView!
    private(set) var imagePickerController = UIImagePickerController()
    
    var dataSource = AddProductDataSource()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverKeyboardNotification()
        tapBehindViewToEndEdit()
        
        setupViewController()
        setupNavigationBar()
        
        view.addSubview(productManagementScrollView)
        productManagementScrollView.setupConstraints(with: view)
        productManagementScrollView.setupSubviews()
        
        setupImageCollectionView()
        setupDescriptionTextView()
        setupImagePickerViewController()
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
        title = ViewTitle.productRegister.description
    }
    
    private func setupImageCollectionView() {
        imageCollectionView = productManagementScrollView.imageCollectionView
        imageCollectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.identifier)
        imageCollectionView.register(AddProductImageFooterView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                     withReuseIdentifier: AddProductImageFooterView.identifier)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView = productManagementScrollView.descriptionTextView
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
        postProductRegister()
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
    
    func textViewDidChange(_ textView: UITextView) {
        let maxDescriptionCount = 999
        if textView.text.count > maxDescriptionCount {
            showRegisterFailAlert(message: .descriptionFailMessage)
        }
    }
}

// MARK: - Keyboard
extension AddProductViewController {
    private func addObserverKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        guard let info = sender.userInfo else {
            return
        }
        
        let userInfo = info as NSDictionary
        guard let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return
        }
        
        let keyboardRect = keyboardFrame.cgRectValue
        productManagementScrollView.contentInset.bottom = keyboardRect.height
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        productManagementScrollView.contentInset.bottom = .zero
    }
    
    func tapBehindViewToEndEdit() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}
