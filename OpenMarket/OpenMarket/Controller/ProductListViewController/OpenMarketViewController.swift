//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class OpenMarketViewController: UIViewController {
    // MARK: - Properties
    var dataSource = OpenMarketDataSource()
 
    private var segmentedControl: LayoutKindSegmentedControl!
    private(set) var productCollectionView: ProductsCollectionView!
    private var activityIndicator: UIActivityIndicatorView!

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
        setupCollectionView()
        setupActivityIndicator()
        registerCell()
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
    
    private func setupProducts() {
        NetworkDataTransfer().fetchData(api: ProductPageAPI(pageNumber: 1, itemsPerPage: 100),
                  decodingType: ProductPage.self) { [weak self] data in
            self?.dataSource.products = data.products
            DispatchQueue.main.async {
                self?.reloadDataWithActivityIndicator(at: self?.productCollectionView)
            }
        }
    }
}

// MARK: - NavigationBar, Segmented Control
extension OpenMarketViewController {
    private func setupNavigationBar() {
        let itemsOfsegmentedControl = OpenMarketDataSource.LayoutKind.allCases.map { $0.description }
        segmentedControl = LayoutKindSegmentedControl(items: itemsOfsegmentedControl)
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
        activityIndicator = UIActivityIndicatorView()
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
    private func setupCollectionView() {
        productCollectionView = ProductsCollectionView(frame: view.bounds,
                                                       collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(productCollectionView)
        productCollectionView.setupConstraints(with: view)
        
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
    }
    
    private func registerCell() {
        OpenMarketDataSource.LayoutKind.allCases.forEach {
            productCollectionView.register($0.cellType, forCellWithReuseIdentifier: $0.cellIdentifier)
        }
    }
}
