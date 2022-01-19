import UIKit

class RoundedRectTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        borderStyle = .roundedRect
        font = .preferredFont(forTextStyle: .subheadline)
    }
}
