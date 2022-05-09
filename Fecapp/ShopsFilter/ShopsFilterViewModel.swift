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

class ShopsFilterViewModel: NSObject, UICollectionViewDelegate {
    let collectionView: UICollectionView
    let shopsDataSource: ShopsDataSource

    var neighborhoods: [Neighborhood]?

    var cancellables = [AnyCancellable]()

    init(collectionView: UICollectionView, dataSource: ShopsDataSource) {
        collectionView.register(
            LabelCollectionViewCell.self,
            forCellWithReuseIdentifier: "LabelCollectionViewCell"
        )

        self.shopsDataSource = dataSource
        self.collectionView = collectionView
        super.init()

        self.collectionView.delegate = self

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
        self.neighborhoods = neighborhoods

        var snapshot = NSDiffableDataSourceSnapshot<Section, Neighborhood>()
        snapshot.appendSections([.main])
        snapshot.appendItems(neighborhoods)
        dataSource.apply(snapshot, animatingDifferences: false)

        neighborhoods.enumerated().forEach { index, neighborhood in
            if shopsDataSource.filteredNeighborhoods.contains(neighborhood) {
                let indexPath = IndexPath(row: index, section: 0)
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            }
        }
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

    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let neighborhoods = neighborhoods else {
            return
        }

        let selected = neighborhoods[indexPath.row]
        LogService.info("Selected \(selected.title)")
        shopsDataSource.filteredNeighborhoods.insert(selected)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let neighborhoods = neighborhoods else {
            return
        }

        let selected = neighborhoods[indexPath.row]
        LogService.info("Deselected \(selected.title)")
        shopsDataSource.filteredNeighborhoods.remove(selected)
    }
}
