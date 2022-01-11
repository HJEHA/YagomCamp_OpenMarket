//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    private var segmentedControl: ViewTypeSegmentedControl!
    var productCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
        setupCollectionView()
        registerCell()
    }
    
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
    
    private func setupViewController() {
        view.backgroundColor = .white
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

// MARK: - NavigationBar
extension ViewController {
    func setupNavigationBar() {
        let segmentedControl = ViewTypeSegmentedControl(items: ["List", "Grid"])
        self.navigationController?.navigationBar.topItem?.titleView = segmentedControl
    }
}

// MARK: - CollectionView Data Source
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridProductCell.identifier, for: indexPath) as? GridProductCell else {
            return GridProductCell()
        }
        
        return cell
    }
}
