//
//  ShopsViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import UIKit

class ShopsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: ShopsDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        createLayout()

        dataSource = ShopsDataSource(collectionView: collectionView)
        dataSource?.fetchShops()
    }

    private func createLayout() {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let itemLayout = NSCollectionLayoutItem(layoutSize: itemSize)
        itemLayout.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 16,
            bottom: 8,
            trailing: 16
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(110)
        )

        let groupLayout = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: itemLayout,
            count: 1
        )

        let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
        let layout = UICollectionViewCompositionalLayout(section: sectionLayout)

        collectionView.collectionViewLayout = layout
    }
}

