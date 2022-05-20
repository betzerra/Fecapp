//
//  RoasterDetailView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 19/05/2022.
//

import Foundation
import UIKit

class RoasterDetailView: UIView {
    let collectionView: UICollectionView

    init() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: Self.collectionViewLayout()
        )

        super.init(frame: .zero)

        collectionView.loadInto(containerView: self)

        collectionView.register(
            RoasterHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )

        backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func collectionViewLayout() -> UICollectionViewLayout {
        // Supplementary Item - Header
        let headerItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerItemSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        return ShopCollectionViewLayout(size: .small, supplementaryItems: [headerItem]).layout()
    }
}
