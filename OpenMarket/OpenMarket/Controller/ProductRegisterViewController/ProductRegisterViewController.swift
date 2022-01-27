import UIKit

enum ViewTitle: String {
    case productRegister = "상품등록"
    
    fileprivate var description: String {
        return self.rawValue
    }
}

final class ProductRegisterViewController: UIViewController {
    // MARK: - Properties
    var dataSource = ProductRegisterDataSource()
    var imagePicker = ProductRegisterImagePicker()
    
    private(set) var productManagementScrollView = ProductManagementScrollView()
    private(set) var imageCollectionView: ProductImageCollectionView!
    private var descriptionTextView: UITextView!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        addObserverKeyboardNotification()
        tapBehindViewToEndEdit()
        
        setupViewController()
        setupNavigationBar()
        
        view.addSubview(productManagementScrollView)
        productManagementScrollView.setupConstraints(with: view)
        productManagementScrollView.setupSubviews()
        
        setupImageCollectionView()
        setupDescriptionTextView()
        setupImagePicker()
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
        title = ViewTitle.productRegister.description
    }
    
    private func setupImageCollectionView() {
        imageCollectionView = productManagementScrollView.imageCollectionView
        imageCollectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.identifier)
        imageCollectionView.register(ProductRegisterImageFooterView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                     withReuseIdentifier: ProductRegisterImageFooterView.identifier)
        imageCollectionView.dataSource = dataSource
        imageCollectionView.delegate = self
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView = productManagementScrollView.descriptionTextView
        descriptionTextView.delegate = self
    }
}

// MARK: - ProductRegister DataSource Delegate
extension ProductRegisterViewController: ProductRegisterDataSourceDelegate {
    private func setupDataSource() {
        self.dataSource.delegate = self
    }
    
    func productRegisterDataSource(didReusedCell cell: ProductImageCell) {
        cell.removeButton.addTarget(self, action: #selector(removeImage), for: .touchUpInside)
        cell.editButton.addTarget(self, action: #selector(editImageOfSelectedItem), for: .touchUpInside)
    }
    
    func productRegisterDataSource(didReusedFooterView footerView: ProductRegisterImageFooterView) {
        footerView.addButton.addTarget(self, action: #selector(touchUpAddProductImageButton), for: .touchUpInside)
    }
    
    func productRegisterDataSourceDidRemoveImage() {
        imageCollectionView.reloadData()
    }
    
    func productRegisterDataSourceDidChangeEditImageFlag() {
        touchUpAddProductImageButton()
    }
    
    func productRegisterDataSourceCompletedPost() {
        DispatchQueue.main.async { [weak self] in
            self?.showRegisterSuccessAlert()
        }
    }
    
    func productRegisterDataSource(failedPost message: ProductRegisterAlertText) {
        showRegisterFailAlert(message: message)
    }
}

// MARK: - ProductRegister ImagePicker Delegate
extension ProductRegisterViewController: ProductRegisterImagePickerDelegate {
    private func setupImagePicker() {
        imagePicker.viewDelegate = self
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    func productRegisterImagePickerDisabledCamera() {
        let okButton = UIAlertAction(title: AddProductImageActionSheetText.confirm.description, style: .default)
        let alert = AlertFactory().createAlert(
                                    title: AddProductImageActionSheetText.cameraDisableAlertTitle.description,
                                    actions: okButton
                                   )
        
        present(alert, animated: true)
    }
    
    func productRegisterImagePickerChangedSourceType() {
        present(imagePicker, animated: true)
    }
}

extension ProductRegisterViewController {
    @objc private func touchUpAddProductImageButton() {
        let library =  UIAlertAction(title: AddProductImageActionSheetText.library.description, style: .default) { _ in
            self.imagePicker.changeSourceTypeToLibrary()
        }
        let camera =  UIAlertAction(title: AddProductImageActionSheetText.camera.description, style: .default) { _ in
            self.imagePicker.changeSourceTypeToCamera()
        }
        let cancel = UIAlertAction(title: AddProductImageActionSheetText.cancel.description, style: .cancel) { _ in
            self.dataSource.isEditingImage = false
        }
        
        let alertTitle = setProductImageAlertTitle()
        let alert = AlertFactory().createAlert(style: .actionSheet,
                                               title: alertTitle,
                                               actions: library, camera, cancel)
        
        present(alert, animated: true)
    }
    
    private func setProductImageAlertTitle() -> String {
        if dataSource.isEditingImage {
            return AddProductImageActionSheetText.editImageAlertTitle.description
        } else {
            return AddProductImageActionSheetText.addImageAlertTitle.description
        }
    }
}

// MARK: - NavigationBar
extension ProductRegisterViewController {
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
        let userInput = productManagementScrollView.createUserInputData()
        dataSource.postProductRegister(userInput)
    }
}

// MARK: - TextView Delegate
extension ProductRegisterViewController: UITextViewDelegate {
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
extension ProductRegisterViewController {
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
