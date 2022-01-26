import UIKit

final class ProductManagementScrollView: UIScrollView {
    private let verticalStackView = UIStackView()
    private(set) var imageCollectionView = ProductImageCollectionView(
                                             frame: CGRect.zero,
                                             collectionViewLayout: UICollectionViewFlowLayout()
                                           )
    private let nameTextField = RoundedRectTextField()
    private let priceTextField = RoundedRectTextField()
    private lazy var currencySegmentedControl: UISegmentedControl = {
        let items = Currency.allCases.map { $0.description }
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.setTitleTextAttributes([.font: UIFont.preferredFont(forTextStyle: .body)], for: .normal)
        segmentedControl.setTitleTextAttributes([.font: UIFont.preferredFont(forTextStyle: .headline)], for: .selected)
        segmentedControl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return segmentedControl
    }()
    private let discountedPriceTextField = RoundedRectTextField()
    private let stockTextField = RoundedRectTextField()
    private(set) var descriptionTextView = UITextView()
    
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
        setupSubviewsAutoresizingMask()
    }
    
    private func setupSubviewsAutoresizingMask() {
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
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
        
        verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        verticalStackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true  
    }
    
    private func setupImageCollectionView() {
        verticalStackView.addArrangedSubview(imageCollectionView)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 14
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3)
        imageCollectionView.collectionViewLayout = flowLayout
        
        imageCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.35).isActive = true
    }
    
    private func setupNameTextField() {
        verticalStackView.addArrangedSubview(nameTextField)
        let namePlaceholder = ProductPlaceholder.name.text
        nameTextField.placeholder = namePlaceholder
    }
    
    private func setupPriceAndCurrencyStackView() {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 8
        
        let pricePlaceholder = ProductPlaceholder.price.text
        priceTextField.placeholder = pricePlaceholder
        priceTextField.keyboardType = .decimalPad
        
        horizontalStackView.addArrangedSubview(priceTextField)
        horizontalStackView.addArrangedSubview(currencySegmentedControl)
        verticalStackView.addArrangedSubview(horizontalStackView)
    }
    
    private func setupDiscountedPriceTextField() {
        verticalStackView.addArrangedSubview(discountedPriceTextField)
        let discountedPricePlaceholder = ProductPlaceholder.discountedPrice.text
        discountedPriceTextField.placeholder = discountedPricePlaceholder
        discountedPriceTextField.keyboardType = .decimalPad
    }
    
    private func setupStockTextField() {
        verticalStackView.addArrangedSubview(stockTextField)
        let stockPlaceholder = ProductPlaceholder.stock.text
        stockTextField.placeholder = stockPlaceholder
        stockTextField.keyboardType = .decimalPad
    }
    
    private func setupDescriptionTextView() {
        verticalStackView.addArrangedSubview(descriptionTextView)
        descriptionTextView.text = ProductPlaceholder.description.text
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.font = .preferredFont(forTextStyle: .body)
        descriptionTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }

    func createUserInputData() -> Result<ProductDetailToRegister, GenerateUserInputError> {
        let userInputChecker = UserInputChecker()
        guard let name = nameTextField.text,
              userInputChecker.checkName(name) else {
            return .failure(.invalidNameCount)
        }
        
        guard let priceText = priceTextField.text,
              let price = Double(priceText) else {
            return .failure(.emptyPrice)
        }
        
        var discountPrice: Double?
        if let discountPriceText = discountedPriceTextField.text,
           let discountPriceAsDouble = Double(discountPriceText) {
            discountPrice = discountPriceAsDouble
        } else {
            discountPrice = 0
        }
        
        guard let discountPrice = discountPrice,
              userInputChecker.checkDiscountedPrice(discountedPrice: discountPrice, price: price) else {
                  return .failure(.invalidDiscountedPrice)
              }
        
        var stock: Int?
        if let stockText = stockTextField.text,
           let stockAsInt = Int(stockText) {
            if userInputChecker.checkStock(stockAsInt) {
                stock = stockAsInt
            } else {
                return .failure(.invalidStock)
            }
        }
        
        guard userInputChecker.checkDescription(descriptionTextView.text) else {
            return .failure(.invalidDescription)
        }
        
        let currency = Currency.allCases[currencySegmentedControl.selectedSegmentIndex]
        
        let productDetailToRegister = ProductDetailToRegister(name: name,
                                                              descriptions: descriptionTextView.text.description,
                                                              price: price,
                                                              discountedPrice: discountPrice,
                                                              currency: currency,
                                                              stock: stock)
        
        return .success(productDetailToRegister)
    }
}

enum GenerateUserInputError: Error {
    case invalidNameCount
    case invalidDiscountedPrice
    case emptyPrice
    case invalidStock
    case invalidDescription
    
    var description: ProductRegisterAlertText {
        switch self {
        case .invalidNameCount:
            return ProductRegisterAlertText.nameFailMessage
        case .invalidDiscountedPrice:
            return ProductRegisterAlertText.discountedPriceFailMessage
        case .emptyPrice:
            return ProductRegisterAlertText.emptyPriceMessage
        case .invalidStock:
            return ProductRegisterAlertText.stockFailMessage
        case .invalidDescription:
            return ProductRegisterAlertText.descriptionFailMessage
        }
    }
}
