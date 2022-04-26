//
//  ShopsDataSource.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import Foundation
import Combine
import Pluma
import UIKit

enum Section {
    case main
}

typealias ShopsDiffableDataSource = UICollectionViewDiffableDataSource<Section, Shop>

class ShopsDataSource {
    let collectionView: UICollectionView

    let baseURL = URL(string: "https://www.tomafeca.com")!
    let pluma: Pluma

    @Published var shops: [Shop]?

    var cancellables = [AnyCancellable]()

    init(collectionView: UICollectionView) {
        self.pluma = Pluma(baseURL: baseURL, decoder: nil)
        self.collectionView = collectionView

        collectionView.register(
            ShopCollectionViewCell.self,
            forCellWithReuseIdentifier: "ShopCollectionViewCell"
        )

        $shops
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] shops in
                var snapshot = NSDiffableDataSourceSnapshot<Section, Shop>()
                snapshot.appendSections([.main])
                snapshot.appendItems(shops)
                self?.dataSource.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)

        fetchShops()
    }

    func fetchShops() {
        Task {
            do {
                shops = try await pluma.request(
                    method: .GET,
                    path: "shops.json",
                    params: nil
                )
            } catch {
                print(error.localizedDescription)
            }
        }
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

                cell.setShop(shop)
                return cell
          })
          return dataSource
    }()
}
