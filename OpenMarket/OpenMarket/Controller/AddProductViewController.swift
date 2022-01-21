import UIKit

enum AddProductImageActionSheetText: String {
    case addImageAlertTitle = "업로드할 사진을 선택해주세요"
    case editImageAlertTitle = "수정할 사진을 선택해주세요"
    case library = "앨범에서 가져오기"
    case camera = "사진 촬영"
    case cancel = "취소"
    case cameraDisableAlertTitle = "카메라를 사용할 수 없음"
    case confirm = "확인"
    
    fileprivate var description: String {
        return self.rawValue
    }
}

enum ProductRegisterAlertText: String {
    case successTitle = "상품 등록이 완료되었습니다"
    case failTitle = "상품 등록에 실패했습니다"
    case imageFailMessage = "이미지는 최소 1장 이상 추가해주세요."
    case nameFailMessage = "상품명을 3글자 이상, 100글자 이하로 입력해주세요."
    case emptyPriceMessage = "상품가격을 입력해주세요."
    case discountedPriceFailMessage = "할인가격이 상품가격보다 큽니다."
    case descriptionFailMessage = "상품 설명은 10글자 이상, 1000글자 이하로 작성해주세요."
    case confirm = "확인"
    
    fileprivate var description: String {
        return self.rawValue
    }
}

private extension UIView {
    func findSuperview<T>(ofType: T.Type) -> T? {
        var currentView = self
        var resultView: T?
        while let currentSuperview = currentView.superview {
            if currentSuperview is T {
                resultView = currentSuperview as? T
                break
            }
            currentView = currentSuperview
        }
        return resultView
    }
}

final class AddProductViewController: UIViewController {
    // MARK: - Properties
    private let productManagementView = ProductManagementView()
    private var imageCollectionView: ProductImageCollectionView!
    private var descriptionTextView: UITextView!
    private let imagePickerController = UIImagePickerController()
    private var imageAddButtonSize = CGSize(width: UIScreen.main.bounds.width * 0.36,
                                            height: UIScreen.main.bounds.width * 0.35)
    
    private var productImages: [UIImage] = [] {
        didSet {
            if productImages.count > 4 {
                imageAddButtonSize = CGSize.zero
            } else {
                imageAddButtonSize = CGSize(width: UIScreen.main.bounds.width * 0.36,
                                            height: UIScreen.main.bounds.width * 0.35)
            }
        }
    }
    private var isEditingImage = false
    private var currentImageCellIndexPath = IndexPath()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverKeyboard()
        setupViewController()
        setupNavigationBar()
        
        view.addSubview(productManagementView)
        productManagementView.setupConstraints(with: view)
        productManagementView.setupSubviews()
        
        setupImageCollectionView()
        setupDescriptionTextView()
        setupImagePickerViewController()
    }
    
    private func addObserverKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(test), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(test2), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func test() {
        productManagementView.contentInset.bottom = 300
    }
    
    @objc private func test2() {
        productManagementView.contentInset.bottom = 0
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
        title = "상품등록"
    }
    
    private func setupImageCollectionView() {
        imageCollectionView = productManagementView.imageCollectionView
        imageCollectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.identifier)
        imageCollectionView.register(AddProductImageFooterView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                     withReuseIdentifier: AddProductImageFooterView.identifier)
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView = productManagementView.descriptionTextView
        descriptionTextView.delegate = self
    }
    
    private func postProductRegister() {
        var multipartFormData = MultipartFormData()
        guard let product = validateUserInput() else {
            return
        }
        
        let productRegisterData = multipartFormData.createFormData(params: "params", item: product)
        multipartFormData.appendToBody(from: productRegisterData)
        
        productImages.forEach { image in
            let imageData = multipartFormData.createImageFormData(name: "images",
                                                                  fileName: "Test.png",
                                                                  contentType: .png,
                                                                  image: image)
            multipartFormData.appendToBody(from: imageData)
        }
        multipartFormData.closeBody()
        
        let postAPI = ProductRegisterAPI(boundary: multipartFormData.boundary, body: multipartFormData.body)
        NetworkDataTransfer().request(api: postAPI) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.showRegisterSuccessAlert()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func validateUserInput() -> ProductDetailToRegister? {
        guard UserInputChecker().checkImage(productImages) else {
            showRegisterFailAlert(message: .imageFailMessage)
            return nil
        }
        
        let result = productManagementView.createUserInputData()
        
        switch result {
        case .success(let generatedData):
            return generatedData
        case .failure(.inefficientNameCount):
            showRegisterFailAlert(message: .nameFailMessage)
        case .failure(.emptyPrice):
            showRegisterFailAlert(message: .emptyPriceMessage)
        case .failure(.invalidDiscountedPrice):
            showRegisterFailAlert(message: .discountedPriceFailMessage)
        case .failure(.invalidDescription):
            showRegisterFailAlert(message: .descriptionFailMessage)
        default:
            print(GenerateUserInputError.unknownError)
        }
        
        return nil
    }
    
    private func showRegisterSuccessAlert() {
        let alert = UIAlertController(title: ProductRegisterAlertText.successTitle.description,
                                      message: nil,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: ProductRegisterAlertText.confirm.description,
                                     style: .default) { [weak self] _ in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(okButton)
        
        present(alert, animated: true)
    }
    
    private func showRegisterFailAlert(message: ProductRegisterAlertText) {
        let alert = UIAlertController(title: ProductRegisterAlertText.failTitle.description,
                                      message: message.description,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: ProductRegisterAlertText.confirm.description, style: .default)
        alert.addAction(okButton)
        
        present(alert, animated: true)
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

// MARK: - ImageCollectionView DataSource
extension AddProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.identifier,
                                                            for: indexPath) as? ProductImageCell else {
            return UICollectionViewCell()
        }
        cell.setupProductImage(with: productImages[indexPath.item])
        cell.removeButton.addTarget(self, action: #selector(removeImage), for: .touchUpInside)
        cell.setIndexPath(at: indexPath)
        return cell
    }
    
    @objc func removeImage(_ sender: UIButton) {
        guard let productImageCell = sender.findSuperview(ofType: ProductImageCell.self),
              let indexPath = productImageCell.indexPath else {
            return
        }
        
        productImages.remove(at: indexPath.item)
        imageCollectionView.reloadData()
    }
}

extension AddProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isEditingImage = true
        currentImageCellIndexPath = indexPath
        touchUpAddProductImageButton()
    }
}

// MARK: - ImageCollectionView Delegate
extension AddProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: AddProductImageFooterView.identifier,
                                                  for: indexPath) as? AddProductImageFooterView else {
            return UICollectionReusableView()
        }
        footerView.addButton.addTarget(self, action: #selector(touchUpAddProductImageButton), for: .touchUpInside)
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return imageAddButtonSize
    }
}

// MARK: - ImagePicker Methods
extension AddProductViewController {
    private func setupImagePickerViewController() {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }
    
    @objc private func touchUpAddProductImageButton() {
        let alertTitle = setProductImageAlertTitle()
        let alert =  UIAlertController(title: alertTitle,
                                       message: nil,
                                       preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: AddProductImageActionSheetText.library.description, style: .default) { _ in
            self.openLibrary() }
        let camera =  UIAlertAction(title: AddProductImageActionSheetText.camera.description, style: .default) { _ in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: AddProductImageActionSheetText.cancel.description, style: .cancel) { _ in
            self.isEditingImage = false
        }
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    private func setProductImageAlertTitle() -> String {
        if isEditingImage {
            return AddProductImageActionSheetText.editImageAlertTitle.description
        } else {
            return AddProductImageActionSheetText.addImageAlertTitle.description
        }
    }
    
    private func openLibrary() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true)
        } else {
            showCameraDisableAlert()
        }
    }
    
    private func showCameraDisableAlert() {
        let alert = UIAlertController(title: AddProductImageActionSheetText.cameraDisableAlertTitle.description,
                                      message: nil,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: AddProductImageActionSheetText.confirm.description, style: .default)
        alert.addAction(okButton)
        
        present(alert, animated: true)
    }
}

// MARK: - ImagePickerController Delegate
extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            isEditingImage = false
            return
        }
        let resizedImage = image.compressImage()
        
        if isEditingImage {
            productImages[currentImageCellIndexPath.item] = resizedImage
        } else {
            productImages.append(resizedImage)
        }
        
        dismiss(animated: true) {
            DispatchQueue.main.async { [weak self] in
                self?.imageCollectionView.reloadDataCompletion { [weak self] in
                    self?.scrollToRightMost()
                }
                self?.isEditingImage = false
            }
        }
    }
    
    private func scrollToRightMost() {
        var rightMostOffsetX = imageCollectionView.contentSize.width
        if rightMostOffsetX > imageCollectionView.frame.width {
            rightMostOffsetX -= imageCollectionView.frame.width
            let offset = CGPoint(x: rightMostOffsetX, y: 0)
            imageCollectionView.setContentOffset(offset, animated: true)
        }
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
