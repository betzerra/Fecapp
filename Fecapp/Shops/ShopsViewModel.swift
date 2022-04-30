//
//  ShopsViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Combine
import Foundation
import UIKit

typealias ShopsDiffableDataSource = UICollectionViewDiffableDataSource<Section, Shop>

class ShopsViewModel {
    private let cellVerticalPadding: CGFloat = 8.0
    private let cellHorizontalPadding: CGFloat = 16.0
    private let cellHeight: CGFloat = 110.0

    let collectionView: UICollectionView

    var cancellables = [AnyCancellable]()

    var layoutColumns: Int {
        UIScreen.main.traitCollection.horizontalSizeClass == .regular ? 2 : 1
    }

    init(collectionView: UICollectionView, dataSource: ShopsDataSource) {
        collectionView.register(
            ShopCollectionViewCell.self,
            forCellWithReuseIdentifier: "ShopCollectionViewCell"
        )

        self.collectionView = collectionView
        setupCollectionViewLayout()

        dataSource.$shops
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] shops in
                self?.refreshDatasource(shops: shops)
            }
            .store(in: &cancellables)

        dataSource.$filteredNeighborhoods
            .receive(on: RunLoop.main)
            .sink { [weak self] neighborhoods in
                guard let shops = dataSource.shops else {
                    return
                }

                if neighborhoods.count == 0 {
                    self?.refreshDatasource(shops: shops)
                    return
                }

                let filteredShops = shops.filter { shop in
                    guard let shopNeighborhood = shop.neighborhood else {
                        return false
                    }

                    return neighborhoods.contains(shopNeighborhood)
                }

                self?.refreshDatasource(shops: filteredShops)
            }
            .store(in: &cancellables)
    }

    private func setupCollectionViewLayout() {
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
            count: layoutColumns
        )

        let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
        let layout = UICollectionViewCompositionalLayout(section: sectionLayout)

        collectionView.collectionViewLayout = layout
    }

    func refreshDatasource(shops: [Shop]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Shop>()
        snapshot.appendSections([.main])
        snapshot.appendItems(shops)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private lazy var dataSource: ShopsDiffableDataSource = {
        let dataSource = UICollectionViewDiffableDataSource<Section, Shop>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, shop) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ShopCollectionViewCell",
                    for: indexPath) as? ShopCollectionViewCell else {
                        return UICollectionViewCell()
                    }

                let viewModel = ShopCellViewModel(shop: shop)
                cell.setViewModel(viewModel)
                return cell
          })
          return dataSource
    }()
}
