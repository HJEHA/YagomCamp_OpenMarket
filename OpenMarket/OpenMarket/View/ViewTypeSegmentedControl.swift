import UIKit

final class ViewTypeSegmentedControl: UISegmentedControl {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        setup()
    }
    
    private func setup() {
        let width = UIScreen.main.bounds.size.width / 2.0
        widthAnchor.constraint(equalToConstant: width).isActive = true
        layer.addBorder([.all], color: UIColor.systemBlue, width: 2, radius: 1)
        
        setTitleTextAttributes([.foregroundColor: UIColor.systemBlue,
                                .font: UIFont.preferredFont(forTextStyle: .body)],
                               for: .normal)
        setTitleTextAttributes([.foregroundColor: UIColor.white,
                                .font: UIFont.preferredFont(forTextStyle: .body)],
                               for: .selected)
        
        selectedSegmentTintColor = .systemBlue
        selectedSegmentIndex = 0
    }
}
