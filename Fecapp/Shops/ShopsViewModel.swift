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
    private let cellVerticalPadding: CGFloat = 8.0
    private let cellHorizontalPadding: CGFloat = 16.0
    private let cellHeight: CGFloat = 110.0

    let collectionView: UICollectionView
    let refreshControl: UIRefreshControl

    private var lastUserLocation: CLLocation?
    private var shops: [Shop]?
    let shopsDataSource: ShopsDataSource

    let events: AnyPublisher<ShopsViewModelEvents, Never>
    private let _events = PassthroughSubject<ShopsViewModelEvents, Never>()
    private var cancellables = [AnyCancellable]()

    var layoutColumns: Int {
        UIScreen.main.traitCollection.horizontalSizeClass == .regular ? 2 : 1
    }

    init(collectionView: UICollectionView, dataSource: ShopsDataSource) {
        collectionView.register(
            ShopCollectionViewCell.self,
            forCellWithReuseIdentifier: "ShopCollectionViewCell"
        )

        self.shopsDataSource = dataSource

        self.collectionView = collectionView
        self.refreshControl = UIRefreshControl()
        self.events = _events.eraseToAnyPublisher()

        super.init()
        self.collectionView.delegate = self
        setupCollectionViewLayout()

        // Bind refresh control to fetch shops if enabled
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(
            self,
            action: #selector(fetchShops),
            for: .valueChanged
        )

        // Bind shops changes to UICollectionView
        dataSource.$shops
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] shops in
                self?.refreshDatasource(shops: shops)
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

    func sortByNearestLocation(_ location: CLLocation) {
        lastUserLocation = location
        shopsDataSource.sortByNearestLocation(location)
    }

    @objc private func fetchShops() {
        Task {
            do {
                refreshControl.beginRefreshing()
                try await shopsDataSource.fetchShops()
                refreshControl.endRefreshing()
            } catch {
                LogService.logError(error)
            }
        }
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
        self.shops = shops

        var snapshot = NSDiffableDataSourceSnapshot<Section, Shop>()
        snapshot.appendSections([.main])
        snapshot.appendItems(shops)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private lazy var dataSource: ShopsDiffableDataSource = {
        let dataSource = UICollectionViewDiffableDataSource<Section, Shop>(
            collectionView: collectionView,
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
                cell.setViewModel(viewModel, location: self.lastUserLocation)
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
