//
//  NewsViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 20/05/2022.
//

import Combine
import Foundation
import UIKit
import SDWebImage

typealias NewsDiffableDataSource = UICollectionViewDiffableDataSource<Section, NewsSummary>

class NewsViewModel: NSObject {
    let view: NewsView
    let newsDataSource = NewsDataSource()

    let events = PassthroughSubject<NewsEvent, Never>()
    private var cancellables = [AnyCancellable]()

    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()

    private lazy var dataSource: NewsDiffableDataSource = {
        // swiftlint:disable:next line_length
        let dataSource = NewsDiffableDataSource(collectionView: view.collectionView) { collectionView, indexPath, post in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cell",
                for: indexPath
            ) as? NewsCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.dateLabel.text = NewsViewModel.dateFormatter.string(from: post.date)
            cell.titleLabel.text = post.title
            cell.subtitleLabel.text = post.subtitle
            cell.authorLabel.text = post.author
            cell.authorImageView.sd_setImage(with: post.authorThumbnail)

            return cell
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

        setCollectionViewDelegate()
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

extension NewsViewModel: UICollectionViewDelegate {
    func setCollectionViewDelegate() {
        view.collectionView.delegate = self
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let news = newsDataSource.news else {
            return
        }

        let item = news[indexPath.row]

        Task {
            do {
                let post = try await newsDataSource.fetchMarkdownPost(url: item.url)
                events.send(.selectedNews(item, body: post))
            } catch {
                LogService.logError(error)
            }
        }
    }
}
