//
//  ShopMenuViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 18/05/2022.
//

import Foundation
import UIKit

typealias ShopMenuDiffableDataSource = UICollectionViewDiffableDataSource<ShopMenuCategory, ShopMenuItem>

class ShopMenuViewModel {
    let view: ShopMenuView

    private lazy var dataSource: ShopMenuDiffableDataSource = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ShopMenuItem> { (cell, _, item) in
            var content = UIListContentConfiguration.valueCell()
            content.text = item.title
            content.secondaryText = item.priceString
            cell.contentConfiguration = content
        }

        let dataSource = ShopMenuDiffableDataSource(collectionView: view.collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }

        dataSource.supplementaryViewProvider = {[weak self](collectionView, kind, indexPath) in
            guard let self = self else { return nil }

            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "section",
                for: indexPath) as? SectionReusableView else {
                return nil
            }

            headerView.titleLabel.text = section.title.capitalized
            return headerView
        }

        return dataSource
    }()

    private func refreshDatasource(menuCategories: [ShopMenuCategory]) {
        var snapshot = NSDiffableDataSourceSnapshot<ShopMenuCategory, ShopMenuItem>()

        snapshot.appendSections(menuCategories)
        menuCategories.forEach { category in
            snapshot.appendItems(category.items, toSection: category)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    init(view: ShopMenuView, menu: [ShopMenuCategory]) {
        self.view = view
        refreshDatasource(menuCategories: menu)
    }
}
