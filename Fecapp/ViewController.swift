//
//  ViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: ShopsDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        createLayout()

        dataSource = ShopsDataSource(collectionView: collectionView)
        dataSource?.fetchShops()
    }

    private func createLayout() {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
    }
}

