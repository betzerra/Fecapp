//
//  ShopsView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 10/05/2022.
//

import Foundation
import UIKit

// UI Constants
private let cellVerticalPadding: CGFloat = 8.0
private let cellHorizontalPadding: CGFloat = 16.0
private let cellHeight: CGFloat = 110.0

class ShopsView: UIView {
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let refreshControl = UIRefreshControl()

    init() {
        super.init(frame: .zero)

        collectionView.addSubview(refreshControl)
        collectionView.loadInto(containerView: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func collectionViewLayout() -> UICollectionViewCompositionalLayout {
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
            count: Self.layoutColumns
        )

        let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
        let layout = UICollectionViewCompositionalLayout(section: sectionLayout)

        return layout
    }

    static var layoutColumns: Int {
        UIScreen.main.traitCollection.horizontalSizeClass == .regular ? 2 : 1
    }
}
