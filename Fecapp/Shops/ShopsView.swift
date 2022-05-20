//
//  ShopsView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 10/05/2022.
//

import Foundation
import UIKit

class ShopsView: UIView {
    let emptyView = EmptyView()

    let collectionView: UICollectionView = {
        let shopLayout = ShopCollectionViewLayout(size: .medium)
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: shopLayout.layout()
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let refreshControl = UIRefreshControl()

    init() {
        super.init(frame: .zero)
        collectionView.addSubview(refreshControl)
        collectionView.loadInto(containerView: self)

        emptyView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refreshLayout() {
        let shopLayout = ShopCollectionViewLayout(size: .medium)
        collectionView.collectionViewLayout = shopLayout.layout()
    }
}
