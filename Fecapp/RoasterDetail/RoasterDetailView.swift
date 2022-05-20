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
            collectionViewLayout: ShopsView.collectionViewLayout()
        )

        super.init(frame: .zero)

        collectionView.loadInto(containerView: self)
        backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
