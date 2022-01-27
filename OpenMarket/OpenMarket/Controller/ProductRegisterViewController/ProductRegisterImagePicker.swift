import UIKit

protocol ProductRegisterImagePickerDelegate: AnyObject {
    func productRegisterImagePickerDisabledCamera()
    func productRegisterImagePickerChangedSourceType()
}

class ProductRegisterImagePicker: UIImagePickerController {
    weak var viewDelegate: ProductRegisterImagePickerDelegate?
    
    func changeSourceTypeToLibrary() {
        sourceType = .photoLibrary
        viewDelegate?.productRegisterImagePickerChangedSourceType()
    }
    
    func changeSourceTypeToCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sourceType = .camera
            viewDelegate?.productRegisterImagePickerChangedSourceType()
        } else {
            viewDelegate?.productRegisterImagePickerDisabledCamera()
        }
    }
}

// MARK: - ImagePickerController Delegate
extension ProductRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            dataSource.isEditingImage = false
            return
        }
        let resizedImage = image.compressImage()
        dataSource.applyImage(resizedImage)
        
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
