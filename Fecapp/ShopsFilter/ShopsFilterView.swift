//
//  ShopsFilterView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 10/05/2022.
//

import Foundation
import UIKit

class ShopsFilterView: UIView {
    let collectionView: UICollectionView

    // UI constants
    private let collectionViewTopMargin: CGFloat = 48.0
    private let collectionViewMargin: CGFloat = 24.0
    private let collectionViewItemSpacing: CGFloat = 6.0
    private let collectionViewLineSpacing: CGFloat = 16.0

    init() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        collectionViewLayout.minimumLineSpacing = collectionViewLineSpacing
        collectionViewLayout.minimumInteritemSpacing = collectionViewItemSpacing
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.allowsMultipleSelection = true

        super.init(frame: .zero)

        let insets = UIEdgeInsets(
            top: collectionViewTopMargin,
            left: collectionViewMargin,
            bottom: collectionViewMargin,
            right: collectionViewMargin
        )

        collectionView.loadInto(containerView: self, insets: insets)
        backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
