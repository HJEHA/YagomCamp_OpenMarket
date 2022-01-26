//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class OpenMarketViewController: UIViewController {
    // MARK: - Properties
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var dataSource = OpenMarketDataSource()
    
    private let segmentedControl = LayoutKindSegmentedControl()
    private let activityIndicator = UIActivityIndicatorView()
    private(set) var productListStackView = ProductListStackView()
    private(set) var productCollectionView: ProductsCollectionView!
    private(set) var refreshControl = UIRefreshControl()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
        setupProductListStackView()
        setupCollectionView()
        setupActivityIndicator()
        registerCell()
        autoCheckNewProduct()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupProducts()
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
    }
    
    private func reloadDataWithActivityIndicator(at collectionView: ProductsCollectionView?) {
        startActivityIndicator()
        collectionView?.reloadDataCompletion { [weak self] in
            self?.endActivityIndicator()
        }
    }
    
    @objc private func setupProducts() {
        NetworkDataTransfer().fetchData(api: ProductPageAPI(pageNumber: 1, itemsPerPage: 100),
                                        decodingType: ProductPage.self) { [weak self] data in
            let firstIndex = 0
            self?.dataSource.products = data.products
            self?.dataSource.currentProductID = data.products[firstIndex].id
            DispatchQueue.main.async {
                self?.reloadDataWithActivityIndicator(at: self?.productCollectionView)
            }
        }
    }
    
    private func autoCheckNewProduct(timeInterval: TimeInterval = 10) {
        Timer.scheduledTimer(timeInterval: timeInterval,
                             target: self,
                             selector: #selector(checkNewProduct),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc private func checkNewProduct() {
        NetworkDataTransfer().fetchData(api: ProductPageAPI(pageNumber: 1, itemsPerPage: 100),
                                        decodingType: ProductPage.self) { [weak self] data in
            let firstIndex = 0
            let latestProductID = data.products[firstIndex].id
            if latestProductID != self?.dataSource.currentProductID {
                DispatchQueue.main.async {
                    self?.productListStackView.showRefreshButton()
                }
            }
        }
    }
}

// MARK: - NavigationBar, Segmented Control
extension OpenMarketViewController {
    private func setupNavigationBar() {
        segmentedControl.addTarget(self, action: #selector(toggleViewTypeSegmentedControl), for: .valueChanged)
        
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(touchUpAddProductButton))
    }
    
    @objc private func touchUpAddProductButton() {
        let addProductViewController = AddProductViewController()
        navigationController?.pushViewController(addProductViewController, animated: true)
    }
}

// MARK: - ActivityIndicator
extension OpenMarketViewController {
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        
        startActivityIndicator()
    }
    
    private func startActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = false
            self?.activityIndicator.startAnimating()
        }
    }
    
    private func endActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
        }
    }
}

// MARK: - CollectionView
extension OpenMarketViewController {
    private func setupProductListStackView() {
        view.addSubview(productListStackView)
        productListStackView.setupConstraints(with: view)
        productListStackView.listRefreshButton.addTarget(self,
                                                         action: #selector(didRefreshed),
                                                         for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        productCollectionView = productListStackView.productCollectionView
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        setupRefreshControl()
    }
    
    private func registerCell() {
        OpenMarketDataSource.LayoutKind.allCases.forEach {
            productCollectionView.register($0.cellType, forCellWithReuseIdentifier: $0.cellIdentifier)
        }
    }
    
    private func setupRefreshControl() {
        productCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didRefreshed), for: .valueChanged)
    }
    
    @objc private func didRefreshed() {
        setupProducts()
        productListStackView.hideRefreshButton()
        productCollectionView.setContentOffset(CGPoint.zero, animated: true)
    }
}
