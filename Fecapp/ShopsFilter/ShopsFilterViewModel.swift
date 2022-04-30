//
//  ShopFilterDataSource.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Combine
import Foundation
import UIKit

typealias NeighborhoodDiffableDataSource = UICollectionViewDiffableDataSource<Section, Neighborhood>

class ShopsFilterViewModel {
    let collectionView: UICollectionView

    var cancellables = [AnyCancellable]()

    init(collectionView: UICollectionView, dataSource: ShopsDataSource) {
        collectionView.register(
            LabelCollectionViewCell.self,
            forCellWithReuseIdentifier: "LabelCollectionViewCell"
        )

        self.collectionView = collectionView

        dataSource.$shops
            .compactMap { $0 }
            .map { shops -> [Neighborhood] in
                // Remove duplicates
                let neighborhoods: Set<Neighborhood> = Set(shops.compactMap { $0.neighborhood })
                return Array(neighborhoods).sorted(by: { $0.title < $1.title })
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] neighborhoods in
                self?.refreshDatasource(neighborhoods: neighborhoods)
            }
            .store(in: &cancellables)
    }

    func refreshDatasource(neighborhoods: [Neighborhood]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Neighborhood>()
        snapshot.appendSections([.main])
        snapshot.appendItems(neighborhoods)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private lazy var dataSource: NeighborhoodDiffableDataSource = {
        let dataSource = UICollectionViewDiffableDataSource<Section, Neighborhood>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, neighborhood) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "LabelCollectionViewCell",
                    for: indexPath) as? LabelCollectionViewCell else {
                        return UICollectionViewCell()
                    }

                cell.setTitle(neighborhood.title)
                return cell
          })
          return dataSource
    }()
}
