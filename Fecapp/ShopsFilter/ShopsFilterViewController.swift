//
//  ShopsFilterViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Foundation
import UIKit

class ShopsFilterViewController: UIViewController {
    let collectionView: UICollectionView
    let viewModel: ShopsFilterViewModel

    // UI constants
    private let collectionViewTopMargin: CGFloat = 32.0
    private let collectionViewMargin: CGFloat = 16.0
    private let collectionViewItemSpacing: CGFloat = 6.0
    private let collectionViewLineSpacing: CGFloat = 16.0

    init(dataSource: ShopsDataSource) {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        collectionViewLayout.minimumLineSpacing = collectionViewLineSpacing
        collectionViewLayout.minimumInteritemSpacing = collectionViewItemSpacing
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.allowsMultipleSelection = true

        viewModel = ShopsFilterViewModel(collectionView: collectionView, dataSource: dataSource)

        super.init(nibName: nil, bundle: nil)
        title = "Filtrar"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground

        addSubviews()
        setupLayout()
    }

    private func addSubviews() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: collectionViewMargin),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: collectionViewTopMargin),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -collectionViewMargin),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -collectionViewMargin)
        ])
    }
}
