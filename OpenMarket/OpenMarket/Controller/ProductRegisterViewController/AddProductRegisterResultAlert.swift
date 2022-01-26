import UIKit

// MARK: - AddProduct Register Result Alert
extension AddProductViewController {
    func showRegisterSuccessAlert() {
        let okButton = UIAlertAction(title: ProductRegisterAlertText.confirm.description,
                                     style: .default) { [weak self] _ in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        let alert =  AlertFactory().createAlert(title: ProductRegisterAlertText.successTitle.description,
                                                actions: okButton)

        present(alert, animated: true)
    }
    
    func showRegisterFailAlert(message: ProductRegisterAlertText) {
        let okButton = UIAlertAction(title: ProductRegisterAlertText.confirm.description, style: .default)
        let alert = AlertFactory().createAlert(title: ProductRegisterAlertText.failTitle.description,
                                               actions: okButton)
                
        present(alert, animated: true)
    }
}
