//
//  NewsViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 20/05/2022.
//

import Combine
import Foundation
import UIKit

typealias NewsDiffableDataSource = UICollectionViewDiffableDataSource<Section, NewsSummary>

private let fontName = "Avenir Next"

class NewsViewModel: NSObject {
    let view: NewsView
    let newsDataSource = NewsDataSource()

    private var cancellables = [AnyCancellable]()

    private lazy var dataSource: NewsDiffableDataSource = {
        // swiftlint:disable:next line_length
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, NewsSummary> { (cell, _, item) in
            var config = UIListContentConfiguration.subtitleCell()

            // Padding and margins
            config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 8, trailing: 8)
            config.textToSecondaryTextVerticalPadding = 8

            // First label
            config.text = item.title
            config.textProperties.font = UIFont.font(name: fontName, forTextStyle: .headline).bold()

            // Secondary label
            config.secondaryText = item.subtitle
            config.secondaryTextProperties.color = .secondaryLabel
            config.secondaryTextProperties.font = UIFont.font(name: fontName, forTextStyle: .caption2)
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

    private func refreshDatasource(posts: [NewsSummary]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, NewsSummary>()

        snapshot.appendSections([.main])
        snapshot.appendItems(posts, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    init(view: NewsView) {
        self.view = view

        super.init()

        newsDataSource
            .$news
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] posts in
                self?.refreshDatasource(posts: posts)
            }
            .store(in: &cancellables)

        // Bind refresh control to fetch shops if enabled
        view.refreshControl.addTarget(
            self,
            action: #selector(fetchNews),
            for: .valueChanged
        )
    }

    @objc private func fetchNews() {
        Task {
            do {
                await view.refreshControl.beginRefreshing()
                try await newsDataSource.fetchNews()
                await view.refreshControl.endRefreshing()
            } catch {
                LogService.logError(error)
            }
        }
    }
}
