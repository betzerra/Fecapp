//
//  NewsViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 20/05/2022.
//

import Foundation
import UIKit

typealias NewsDiffableDataSource = UICollectionViewDiffableDataSource<Section, NewsPost>

class NewsViewModel {
    let view: NewsView

    private lazy var dataSource: NewsDiffableDataSource = {
        // swiftlint:disable:next line_length
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, NewsPost> { (cell, _, item) in
            var config = UIListContentConfiguration.subtitleCell()
            config.text = item.title
            config.secondaryText = item.subtitle
            config.secondaryTextProperties.color = .secondaryLabel
            cell.contentConfiguration = config
        }

        // swiftlint:disable:next line_length
        let dataSource = NewsDiffableDataSource(collectionView: view.collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }

        return dataSource
    }()

    private func refreshDatasource(posts: [NewsPost]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, NewsPost>()

        snapshot.appendSections([.main])
        snapshot.appendItems(posts, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    init(view: NewsView) {
        let posts = [
            NewsPost(
                title: "5 V60 Recipes By Rao, Hoffman & Kasuya For Perfect Drip Coffee Everytime",
                subtitle: "Despite being simple, the pour over is one of the most challenging brewing methods to master. These Hario V60 recipe ideas will help you get great coffee."
            )
        ]

        self.view = view
        refreshDatasource(posts: posts)
    }
}
