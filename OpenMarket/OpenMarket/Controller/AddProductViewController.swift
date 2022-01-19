import UIKit

enum AddProductImageActionSheetText: String {
    case optionAlertTitle = "업로드할 사진을 선택해주세요"
    case library = "앨범에서 가져오기"
    case camera = "사진 촬영"
    case cancel = "취소"
    case cameraDisableAlertTitle = "카메라를 사용할 수 없음"
    case confirm = "확인"
    
    fileprivate var description: String {
        return self.rawValue
    }
}

final class AddProductViewController: UIViewController {
    // MARK: - Properties
    private let productManagementView = ProductManagementView()
    private var imageCollectionView: UICollectionView!
    private var descriptionTextView: UITextView!
    private let imagePickerController = UIImagePickerController()
    
    private var productImages: [UIImage] = []
    private var isEditingImage = false
    private var currentImageCellIndexPath = IndexPath()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
        
        view.addSubview(productManagementView)
        productManagementView.setupConstraints(with: view)
        productManagementView.setupSubviews()
        
        setupImageCollectionView()
        setupDescriptionTextView()
        setupImagePickerViewController()
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
        guard let productImageCell = sender.superview?.superview as? ProductImageCell,
              let indexPath = productImageCell.indexPath else {
            return
        }
        
        imageCollectionView.deleteItems(at: [indexPath])
        productImages.remove(at: indexPath.item)
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
        return CGSize(width: UIScreen.main.bounds.width * 0.36, height: UIScreen.main.bounds.width * 0.35)
    }
}

// MARK: - ImagePicker Methods
extension AddProductViewController {
    private func setupImagePickerViewController() {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }
    
    @objc private func touchUpAddProductImageButton() {
        let alert =  UIAlertController(title: AddProductImageActionSheetText.optionAlertTitle.description,
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
        
        if isEditingImage {
            productImages[currentImageCellIndexPath.item] = image
        } else {
            productImages.append(image)
        }
        
        dismiss(animated: true) {
            DispatchQueue.main.async { [weak self] in
                self?.imageCollectionView.reloadData()
                self?.isEditingImage = false
            }
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
}
