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

// MARK: - NavigationBar
extension OpenMarketViewController {
    func setupNavigationBar() {
        let segmentedControl = ViewTypeSegmentedControl(items: ["List", "Grid"])
        self.navigationController?.navigationBar.topItem?.titleView = segmentedControl
    }
}

// MARK: - NavigationBar
extension OpenMarketViewController {
    private func setupGridFlowLayout() -> UICollectionViewFlowLayout {
        let gridFlowLayout = UICollectionViewFlowLayout()
        let inset: Double = 10
        gridFlowLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        gridFlowLayout.minimumLineSpacing = 10
        gridFlowLayout.minimumInteritemSpacing = 10
        gridFlowLayout.scrollDirection = .vertical
        let fullWidth = self.view.bounds.width / 2 - gridFlowLayout.minimumInteritemSpacing * 2
        gridFlowLayout.itemSize = CGSize(width: fullWidth, height: 300)
        return gridFlowLayout
    }
    
    private func setupCollectionView() {
        productCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: setupGridFlowLayout())
        self.view.addSubview(productCollectionView)
        
        productCollectionView.translatesAutoresizingMaskIntoConstraints = false
        productCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        productCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        productCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        productCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        productCollectionView.dataSource = self
    }
    
    private func registerCell() {
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridProductCell.identifier,
                                                            for: indexPath) as? GridProductCell else {
            return GridProductCell()
        }
        
        guard let product = products?[indexPath.item],
              let thumbnailURL = URL(string: product.thumbnail),
              let thumbnailData = try? Data(contentsOf: thumbnailURL) else {
            fatalError()
        }
        
        DispatchQueue.main.async {
            if indexPath == collectionView.indexPath(for: cell) {
                cell.productThumbnailView.image = UIImage(data: thumbnailData)
            }
        }
        cell.nameLabel.text = product.name
        cell.priceLabel.text = "\(product.price)"
        cell.bargainPriceLabel.text = "\(product.bargainPrice)"
        cell.stockLabel.text = "\(product.stock)"
        
        return cell
    }
}
