import UIKit

final class ProductManagementView: UIScrollView {
    private var verticalStackView = UIStackView()
    private(set) var imageCollectionView = UICollectionView(frame: CGRect.zero,
                                                            collectionViewLayout: UICollectionViewFlowLayout())
    private var nameTextField = UITextField()
    private var priceTextField = UITextField()
    private var currencySegmentedControl = UISegmentedControl(items: ["1", "2"])
    
    private var discountedPriceTextField = UITextField()
    private var stockTextField = UITextField()
    private var descriptionTextView = UITextView()
    
    func setupConstraints(with superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor)
            .isActive = true
        trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor)
            .isActive = true
        topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor)
            .isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            .isActive = true
        widthAnchor.constraint(equalToConstant: superview.frame.width).isActive = true
    }
    
    func setupSubviews() {        
        setupVerticalStackView()
        setupImageCollectionView()
        setupNameTextField()
        setupPriceAndCurrencyStackView()
        setupDiscountedPriceTextField()
        setupStockTextField()
        setupDescriptionTextView()
    }

    private func setupVerticalStackView() {
        addSubview(verticalStackView)
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 10
        let inset: CGFloat = 15
        verticalStackView.layoutMargins = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        verticalStackView.isLayoutMarginsRelativeArrangement = true
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        verticalStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    }
    
    private func setupImageCollectionView() {
        verticalStackView.addArrangedSubview(imageCollectionView)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3)
        imageCollectionView.collectionViewLayout = flowLayout
        
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.35).isActive = true
    }
        
    private func setupNameTextField() {
        verticalStackView.addArrangedSubview(nameTextField)
        let namePlaceholder = "상품명"
        nameTextField.placeholder = namePlaceholder
        nameTextField.borderStyle = .roundedRect
        nameTextField.font = .preferredFont(forTextStyle: .subheadline)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupPriceAndCurrencyStackView() {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 8
        
        horizontalStackView.addArrangedSubview(priceTextField)
        let pricePlaceholder = "상품가격"
        priceTextField.placeholder = pricePlaceholder
        priceTextField.borderStyle = .roundedRect
        priceTextField.font = .preferredFont(forTextStyle: .subheadline)
        
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalStackView.addArrangedSubview(currencySegmentedControl)
        currencySegmentedControl.setTitle("\(Currency.koreanWon.description)", forSegmentAt: 0)
        currencySegmentedControl.setTitle("\(Currency.unitedStatesDollar.description)", forSegmentAt: 1)
        currencySegmentedControl.selectedSegmentIndex = 0
        
        currencySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        currencySegmentedControl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        verticalStackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupDiscountedPriceTextField() {
        verticalStackView.addArrangedSubview(discountedPriceTextField)
        let discountedPricePlaceholder = "할인금액"
        discountedPriceTextField.placeholder = discountedPricePlaceholder
        discountedPriceTextField.borderStyle = .roundedRect
        discountedPriceTextField.font = .preferredFont(forTextStyle: .subheadline)
        
        discountedPriceTextField.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupStockTextField() {
        verticalStackView.addArrangedSubview(stockTextField)
        let stockPlaceholder = "재고수량"
        stockTextField.placeholder = stockPlaceholder
        stockTextField.borderStyle = .roundedRect
        stockTextField.font = .preferredFont(forTextStyle: .subheadline)
        
        stockTextField.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupDescriptionTextView() {
        verticalStackView.addArrangedSubview(descriptionTextView)
        descriptionTextView.text = "아름답고 열정 TESTTESTTEST\nTESTTESTTEST\nTESTTESTTESTTESTTEST"
        descriptionTextView.backgroundColor = .cyan
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.heightAnchor.constraint(equalToConstant: 1000.0).isActive = true
        descriptionTextView.font = .preferredFont(forTextStyle: .subheadline)
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
    }
}
