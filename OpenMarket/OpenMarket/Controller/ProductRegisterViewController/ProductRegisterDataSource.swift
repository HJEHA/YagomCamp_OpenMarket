import UIKit

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

protocol ProductRegisterDataSourceDelegate: AnyObject {
    func productRegisterDataSource(didReusedCell cell: ProductImageCell)
    func productRegisterDataSource(didReusedFooterView footerView: ProductRegisterImageFooterView)
    func productRegisterDataSourceDidRemoveImage()
    func productRegisterDataSourceDidChangeEditImageFlag()
    func productRegisterDataSourceCompletedPost()
    func productRegisterDataSource(failedPost message: ProductRegisterAlertText)
}

final class ProductRegisterDataSource: NSObject {
    weak var delegate: ProductRegisterDataSourceDelegate?
    
    static let defaultImageAddFooterViewSize = CGSize(width: UIScreen.main.bounds.width * 0.36,
                                                      height: UIScreen.main.bounds.width * 0.35)
    private(set) var imageAddFooterViewSize = ProductRegisterDataSource.defaultImageAddFooterViewSize
    
    private(set) var productImages: [UIImage] = [] {
        didSet {
            if productImages.count > 4 {
                imageAddFooterViewSize = CGSize.zero
            } else {
                imageAddFooterViewSize = ProductRegisterDataSource.defaultImageAddFooterViewSize
            }
        }
    }
    var isEditingImage = false
    private(set) var currentImageCellIndex = 0
    
    func touchedImageRemoveButton(at index: Int) {
        productImages.remove(at: index)
        delegate?.productRegisterDataSourceDidRemoveImage()
    }
    
    func touchedEditImageButton(at index: Int) {
        isEditingImage = true
        currentImageCellIndex = index
        delegate?.productRegisterDataSourceDidChangeEditImageFlag()
    }
    
    func applyImage(_ image: UIImage) {
        if isEditingImage {
            productImages[currentImageCellIndex] = image
        } else {
            productImages.append(image)
        }
    }
    
    func postProductRegister(_ userInput: Result<ProductDetailToRegister, GenerateUserInputError>) {
        var multipartFormData = MultipartFormData()
        guard let product = validateUserInput(userInput) else {
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
                self?.delegate?.productRegisterDataSourceCompletedPost()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func validateUserInput(
                    _ userInput: Result<ProductDetailToRegister, GenerateUserInputError>
                 ) -> ProductDetailToRegister? {
        guard UserInputChecker().checkImage(productImages) else {
            delegate?.productRegisterDataSource(failedPost: .imageFailMessage)
            return nil
        }
        
        switch userInput {
        case .success(let generatedData):
            return generatedData
        case .failure(let error):
            delegate?.productRegisterDataSource(failedPost: error.description)
        }
        
        return nil
    }
}

// MARK: - ImageCollectionView DataSource
extension ProductRegisterDataSource: UICollectionViewDataSource {
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
        delegate?.productRegisterDataSource(didReusedCell: cell)
        cell.setIndexPath(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: ProductRegisterImageFooterView.identifier,
                                                  for: indexPath) as? ProductRegisterImageFooterView else {
            return UICollectionReusableView()
        }
        delegate?.productRegisterDataSource(didReusedFooterView: footerView)
        
        return footerView
    }
}

extension ProductRegisterViewController {
    @objc func removeImage(_ sender: UIButton) {
        guard let productImageCell = sender.findSuperview(ofType: ProductImageCell.self),
              let indexPath = productImageCell.indexPath else {
            return
        }
        
        dataSource.touchedImageRemoveButton(at: indexPath.item)
    }
    
    @objc func editImageOfSelectedItem(_ sender: UIButton) {
        guard let productImageCell = sender.findSuperview(ofType: ProductImageCell.self),
              let indexPath = productImageCell.indexPath else {
            return
        }
        
        dataSource.touchedEditImageButton(at: indexPath.item)
    }
}

// MARK: - ImageCollectionView Delegate
extension ProductRegisterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return dataSource.imageAddFooterViewSize
    }
}
