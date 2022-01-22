import UIKit

// MARK: - ImagePicker Methods
extension AddProductViewController {
    func setupImagePickerViewController() {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }
    
    @objc func touchUpAddProductImageButton() {
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
            self.dataSource.isEditingImage = false
        }
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    private func setProductImageAlertTitle() -> String {
        if dataSource.isEditingImage {
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
            dataSource.isEditingImage = false
            return
        }
        let resizedImage = image.compressImage()
        
        if dataSource.isEditingImage {
            dataSource.productImages[dataSource.currentImageCellIndexPath.item] = resizedImage
        } else {
            dataSource.productImages.append(resizedImage)
        }
        
        dismiss(animated: true) {
            DispatchQueue.main.async { [weak self] in
                self?.imageCollectionView.reloadDataCompletion { [weak self] in
                    self?.scrollToRightMost()
                }
                self?.dataSource.isEditingImage = false
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
