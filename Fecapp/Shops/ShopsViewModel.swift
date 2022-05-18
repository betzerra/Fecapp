//
//  ShopsViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Combine
import CoreLocation
import Foundation
import UIKit

typealias ShopsDiffableDataSource = UICollectionViewDiffableDataSource<Section, Shop>

enum ShopsViewModelEvents {
    case shopSelected(Shop)
}

class ShopsViewModel: NSObject, UICollectionViewDelegate {
    let view: ShopsView

    private var shops: [Shop]?
    let shopsDataSource: ShopsDataSource

    let events: AnyPublisher<ShopsViewModelEvents, Never>
    private let _events = PassthroughSubject<ShopsViewModelEvents, Never>()
    private var cancellables = [AnyCancellable]()

    init(view: ShopsView, dataSource: ShopsDataSource) {
        view.collectionView.register(
            ShopCollectionViewCell.self,
            forCellWithReuseIdentifier: "ShopCollectionViewCell"
        )

        self.view = view
        self.shopsDataSource = dataSource

        self.events = _events.eraseToAnyPublisher()

        super.init()
        view.collectionView.delegate = self

        // Bind refresh control to fetch shops if enabled
        view.refreshControl.addTarget(
            self,
            action: #selector(fetchShops),
            for: .valueChanged
        )

        // Bind shops changes to UICollectionView
        dataSource.$shops
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] shops in
                guard let self = self else {
                    return
                }

                // Hide / Show empty view
                self.view.emptyView.isHidden = shops.count > 0

                // Update collection view
                self.refreshDatasource(shops: shops)
            }
            .store(in: &cancellables)

        // Bind neighborhoods picks to UICollectionView
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

    @objc private func fetchShops() {
        Task {
            do {
                view.refreshControl.beginRefreshing()
                try await shopsDataSource.fetchShops()
                view.refreshControl.endRefreshing()
            } catch {
                LogService.logError(error)
            }
        }
    }

    func refreshDatasource(shops: [Shop]) {
        self.shops = shops

        var snapshot = NSDiffableDataSourceSnapshot<Section, Shop>()
        snapshot.appendSections([.main])
        snapshot.appendItems(shops)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private lazy var dataSource: ShopsDiffableDataSource = {
        let dataSource = UICollectionViewDiffableDataSource<Section, Shop>(
            collectionView: view.collectionView,
            cellProvider: { [weak self](collectionView, indexPath, shop) -> UICollectionViewCell? in
                guard let self = self else {
                    return UICollectionViewCell()
                }

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

    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selected = shops?[indexPath.row] else {
            return
        }

        _events.send(.shopSelected(selected))
    }
}
