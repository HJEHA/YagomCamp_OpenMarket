//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    private var segmentedControl: ViewTypeSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
    }
    
    private func setupViewController() {
        view.backgroundColor = .white
    }
}

// MARK: - NavigationBar
extension ViewController {
    func setupNavigationBar() {
        let segmentedControl = ViewTypeSegmentedControl(items: ["List", "Grid"])
        self.navigationController?.navigationBar.topItem?.titleView = segmentedControl
    }
}
