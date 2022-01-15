//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class OpenMarketViewController: UIViewController {
    // MARK: - Properties
    private enum LayoutKind: String, CaseIterable, CustomStringConvertible {
        case list = "LIST"
        case grid = "GRID"
        
        var description: String {
            return self.rawValue
        }
        
        var cellIdentifier: String {
            switch self {
            case .list:
                return ListProductCell.identifier
            case .grid:
                return GridProductCell.identifier
            }
        }
        
        var cellType: ProductCellProtocol.Type {
            switch self {
            case .list:
                return ListProductCell.self
            case .grid:
                return GridProductCell.self
            }
        }
    }
    
    private var currentLayoutKind: LayoutKind = .list
    private var products: [Product]?
    
    private var segmentedControl: ViewTypeSegmentedControl!
    private var productCollectionView: UICollectionView!
    private var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
        setupCollectionView()
        setupActivityIndicator()
        registerCell()
        
        setupProducts()
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
    }
    
    private func reloadDataWithActivityIndicator(at collectionView: UICollectionView?) {
        collectionView?.performBatchUpdates {
            startActivityIndicator()
            collectionView?.reloadData()
        } completion: { [weak self] _ in
            self?.endActivityIndicator()
        }
    }
    
    private func setupProducts() {
        NetworkDataTransfer().fetchData(api: ProductPageAPI(pageNumber: 1, itemsPerPage: 100),
                  decodingType: ProductPage.self) { [weak self] data in
            self?.products = data.products
            DispatchQueue.main.async {
                self?.reloadDataWithActivityIndicator(at: self?.productCollectionView)
            }
        }
    }
}

// MARK: - NavigationBar, Segmented Control
extension OpenMarketViewController {
    private func setupNavigationBar() {
        let itemsOfsegmentedControl = LayoutKind.allCases.map { $0.description }
        segmentedControl = ViewTypeSegmentedControl(items: itemsOfsegmentedControl)
        segmentedControl.addTarget(self, action: #selector(toggleViewTypeSegmentedControl), for: .valueChanged)
        
        let navigationBarItem = navigationController?.navigationBar.topItem
        navigationBarItem?.titleView = segmentedControl        
        navigationBarItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self,
                                                                action: #selector(touchUpAddProductButton))
    }
    
    @objc private func toggleViewTypeSegmentedControl(_ sender: UISegmentedControl) {
        let currentScrollRatio: CGFloat = currentScrollRatio()
        currentLayoutKind = LayoutKind.allCases[sender.selectedSegmentIndex]
        
        productCollectionView.performBatchUpdates(nil) { [weak self] _ in
            DispatchQueue.main.async {
                if let nextViewMaxHeight = self?.productCollectionView.contentSize.height {
                    let offset = CGPoint(x: 0, y: nextViewMaxHeight * currentScrollRatio)
                    self?.productCollectionView.setContentOffset(offset, animated: false)
                    self?.productCollectionView.reloadData()
                }
            }
        }
    }
    
    private func currentScrollRatio() -> CGFloat {
        return productCollectionView.contentOffset.y / productCollectionView.contentSize.height
    }
    
    @objc private func touchUpAddProductButton() {
        let addProductViewController = AddProductViewController()
        self.present(addProductViewController, animated: true, completion: nil)
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
        productCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
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
        productCollectionView.delegate = self
    }
    
    private func registerCell() {
        LayoutKind.allCases.forEach {
            productCollectionView.register($0.cellType, forCellWithReuseIdentifier: $0.cellIdentifier)
        }
    }
}

// MARK: - CollectionView Data Source
extension OpenMarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: currentLayoutKind.cellIdentifier,
                                                            for: indexPath) as? ProductCellProtocol else {
            return UICollectionViewCell()
        }
        
        guard let product = products?[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        cell.updateView(with: product)        
        
        return cell
    }
}

// MARK: - CollectionView Delegate FlowLayout
extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch currentLayoutKind {
        case .list:
            let listCellSize: (width: CGFloat, height: CGFloat) = (view.frame.width, view.frame.height * 0.077)
            return CGSize(width: listCellSize.width, height: listCellSize.height)
        case .grid:
            let gridCellSize: (width: CGFloat, height: CGFloat) = (view.frame.width * 0.45, view.frame.height * 0.32)
            return CGSize(width: gridCellSize.width, height: gridCellSize.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: Double = 10
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch currentLayoutKind {
        case .list:
            let listCellLineSpacing: CGFloat = 2
            return listCellLineSpacing
        case .grid:
            let gridCellLineSpacing: CGFloat = 10
            return gridCellLineSpacing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch currentLayoutKind {
        case .list:
            let listCellIteritemSpacing: CGFloat = 0
            return listCellIteritemSpacing
        case .grid:
            let gridCellIteritemSpacing: CGFloat = 10
            return gridCellIteritemSpacing
        }
    }
}
