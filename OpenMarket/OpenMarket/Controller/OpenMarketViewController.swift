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
    private var cellIdentifier: String = ListProductCell.identifier
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
            cellIdentifier = ListProductCell.identifier
        } else {
            cellIdentifier = GridProductCell.identifier
        }
        
        productCollectionView.reloadData()
        productCollectionView.setContentOffset(CGPoint.zero, animated: false)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                            for: indexPath) as? ProductCellProtocol else {
            fatalError()
        }
        
        guard let product = products?[indexPath.item] else {
            fatalError()
        }
        
        DispatchQueue.global().async {
            guard let thumbnailURL = URL(string: product.thumbnail),
                  let thumbnailData = try? Data(contentsOf: thumbnailURL),
                  let thumbnailImage = UIImage(data: thumbnailData) else {
                fatalError()
            }
            
            DispatchQueue.main.async {
                cell.updateThumbnailView(with: thumbnailImage)
            }
        }
        cell.updateLabels(with: product)
        
        return cell
    }
}

extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.cellIdentifier == ListProductCell.identifier {
            let listCellSize: (width: CGFloat, height: CGFloat) = (view.frame.width, view.frame.height * 0.077)
            return CGSize(width: listCellSize.width, height: listCellSize.height)
        } else {
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
        if self.cellIdentifier == ListProductCell.identifier {
            let listCellLineSpacing: CGFloat = 2
            return listCellLineSpacing
        } else {
            let gridCellLineSpacing: CGFloat = 10
            return gridCellLineSpacing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if self.cellIdentifier == ListProductCell.identifier {
            let listCellIteritemSpacing: CGFloat = 0
            return listCellIteritemSpacing
        } else {
            let gridCellIteritemSpacing: CGFloat = 10
            return gridCellIteritemSpacing
        }
    }
}
