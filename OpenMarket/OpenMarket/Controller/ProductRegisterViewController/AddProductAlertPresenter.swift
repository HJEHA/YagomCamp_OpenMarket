import UIKit

// MARK: - AddProduct Alert Presenter
extension AddProductViewController {
    func showRegisterSuccessAlert() {
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
    
    func showRegisterFailAlert(message: ProductRegisterAlertText) {
        let alert = UIAlertController(title: ProductRegisterAlertText.failTitle.description,
                                      message: message.description,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: ProductRegisterAlertText.confirm.description, style: .default)
        alert.addAction(okButton)
        
        present(alert, animated: true)
    }
}
