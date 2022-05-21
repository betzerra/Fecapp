//
//  NewsView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 20/05/2022.
//

import Foundation
import UIKit

class NewsView: UIView {
    let collectionView: UICollectionView
    let refreshControl = UIRefreshControl()

    init() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: NewsView.createLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)

        collectionView.loadInto(containerView: self)
        collectionView.addSubview(refreshControl)

        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}
