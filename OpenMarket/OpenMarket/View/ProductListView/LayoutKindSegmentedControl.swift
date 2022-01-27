import UIKit

final class LayoutKindSegmentedControl: UISegmentedControl {
    static let itemsOfsegmentedControl = ProductListDataSource.LayoutKind.allCases.map { $0.description }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(items: [Any]? = itemsOfsegmentedControl) {
        super.init(items: items)
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
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
