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

    // UI constants
    private let cellVerticalPadding: CGFloat = 8.0
    private let cellHorizontalPadding: CGFloat = 16.0
    private let cellHeight: CGFloat = 110.0

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
            top: cellVerticalPadding,
            leading: cellHorizontalPadding,
            bottom: cellVerticalPadding,
            trailing: cellHorizontalPadding
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(cellHeight)
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

