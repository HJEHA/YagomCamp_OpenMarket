//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    private var segmentedControl: ViewTypeSegmentedControl!
    private var productCollectionView: UICollectionView!
    
    private var products: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
        setupCollectionView()
        registerCell()
        
        fetchProductData()
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
    }
    
    private func fetchProductData() {
        NetworkDataTransfer().request(api: ProductPageAPI(pageNumber: 1, itemsPerPage: 100)) { result in
            switch result {
            case .success(let data):
                self.products = try? JSONParser<ProductPage>().decode(from: data).get().products
                DispatchQueue.main.async {
                    self.productCollectionView.reloadData()
                }
            case .failure(_):
                print("에러")
            }
        }
    }
}

// MARK: - NavigationBar, Segmented Control
extension OpenMarketViewController {
    func setupNavigationBar() {
        segmentedControl = ViewTypeSegmentedControl(items: ["List", "Grid"])
        segmentedControl.addTarget(self, action: #selector(segmentedControlTouched(_:)), for: .valueChanged)
        self.navigationController?.navigationBar.topItem?.titleView = segmentedControl
    }
    
    @objc func segmentedControlTouched(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            productCollectionView.collectionViewLayout = setupListFlowLayout()
        } else {
            productCollectionView.collectionViewLayout = setupGridFlowLayout()
        }
        
        productCollectionView.reloadData()
        productCollectionView.setContentOffset(CGPoint.zero, animated: false)
    }
}

// MARK: - CollectionView
extension OpenMarketViewController {
    private func setupGridFlowLayout() -> UICollectionViewFlowLayout {
        let gridFlowLayout = UICollectionViewFlowLayout()
        let inset: Double = 10
        gridFlowLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        gridFlowLayout.minimumLineSpacing = 10
        gridFlowLayout.minimumInteritemSpacing = 10
        gridFlowLayout.scrollDirection = .vertical
        let fullWidth = self.view.bounds.width / 2 - gridFlowLayout.minimumInteritemSpacing * 2
        let customHeight = self.view.bounds.height / 3 - gridFlowLayout.minimumLineSpacing * 2
        gridFlowLayout.itemSize = CGSize(width: fullWidth, height: customHeight)
        return gridFlowLayout
    }
    
    private func setupListFlowLayout() -> UICollectionViewFlowLayout {
        let listFlowLayout = UICollectionViewFlowLayout()
        let inset: Double = 10
        listFlowLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        listFlowLayout.minimumLineSpacing = 2
        listFlowLayout.scrollDirection = .vertical
        let fullWidth = self.view.bounds.width
        let customHeight = self.view.bounds.height / 13
        listFlowLayout.itemSize = CGSize(width: fullWidth, height: customHeight)
        return listFlowLayout
    }
    
    private func setupCollectionView() {
        productCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: setupListFlowLayout())
        self.view.addSubview(productCollectionView)
        
        productCollectionView.translatesAutoresizingMaskIntoConstraints = false
        productCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            .isActive = true
        productCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            .isActive = true
        productCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            .isActive = true
        productCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            .isActive = true
        
        productCollectionView.dataSource = self
    }
    
    private func registerCell() {
        productCollectionView.register(ListProductCell.self, forCellWithReuseIdentifier: ListProductCell.identifier)
        productCollectionView.register(GridProductCell.self, forCellWithReuseIdentifier: GridProductCell.identifier)
    }
}

// MARK: - CollectionView Data Source
extension OpenMarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ProductCellProtocol
        
        if segmentedControl.selectedSegmentIndex == 0 {
            cell = collectionView.dequeueReusableCell(withClass: ListProductCell.self, for: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withClass: GridProductCell.self, for: indexPath)
        }
        
        guard let product = products?[indexPath.item],
              let thumbnailURL = URL(string: product.thumbnail),
              let thumbnailData = try? Data(contentsOf: thumbnailURL) else {
            fatalError()
        }
        
        DispatchQueue.main.async {
            if indexPath == collectionView.indexPath(for: cell as? UICollectionViewCell ?? UICollectionViewCell()) {
                cell.productThumbnailView.image = UIImage(data: thumbnailData)
            }
        }
  
        cell.nameLabel.text = product.name
        cell.changePriceAnddiscountedPriceLabel(price: product.price,
                                                discountedPrice: product.discountedPrice,
                                                bargainPrice: product.bargainPrice,
                                                currency: product.currency)
        cell.changeStockLabel(by: product.stock)
        
        return cell as? UICollectionViewCell ?? UICollectionViewCell()
    }
}
