import UIKit

// MARK: - ProductRegister Result Alert
extension ProductRegisterViewController {
    func showRegisterSuccessAlert() {
        let okButton = UIAlertAction(title: ProductRegisterAlertText.confirm.description,
                                     style: .default) { [weak self] _ in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
                // Todo: 첫번째 화면한테 상품 갱신하라고 시켜라
            }
        }
        let alert =  AlertFactory().createAlert(title: ProductRegisterAlertText.successTitle.description,
                                                actions: okButton)

        present(alert, animated: true)
    }
    
    func showRegisterFailAlert(message: ProductRegisterAlertText) {
        let okButton = UIAlertAction(title: ProductRegisterAlertText.confirm.description, style: .default)
        let alert = AlertFactory().createAlert(title: ProductRegisterAlertText.failTitle.description,
                                               message: message.description,
                                               actions: okButton)
                
        present(alert, animated: true)
    }
}
