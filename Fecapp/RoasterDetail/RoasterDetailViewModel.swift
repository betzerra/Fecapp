//
//  RoasterDetailViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 19/05/2022.
//

import Foundation
import UIKit

class RoasterDetailViewModel {
    private lazy var dataSource: ShopsDiffableDataSource = {
        let dataSource = UICollectionViewDiffableDataSource<Section, Shop>(
            collectionView: view.collectionView,
            cellProvider: { [weak self](collectionView, indexPath, shop) -> UICollectionViewCell? in
                guard let self = self else {
                    return UICollectionViewCell()
                }

                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ShopCollectionViewCell",
                    for: indexPath) as? ShopCollectionViewCell else {
                    return UICollectionViewCell()
                }

                let viewModel = ShopCellViewModel(shop: shop)
                cell.setViewModel(viewModel)
                return cell
            })

        return dataSource
    }()

    var attributedInstagram: NSAttributedString {
        guard let linkImage = UIImage(named: "instagram", in: Bundle.main, with: nil) else {
            return NSAttributedString(string: roaster.instagram)
        }

        let attachment = NSTextAttachment(image: linkImage)
        let string = NSMutableAttributedString(attachment: attachment)
        string.append(NSAttributedString(string: " \(roaster.instagram)"))

        return string
    }

    let view: RoasterDetailView

    let roaster: Roaster

    init(roaster: Roaster, shops: [Shop], view: RoasterDetailView) {
        self.roaster = roaster
        self.view = view

        view.collectionView.register(
            ShopCollectionViewCell.self,
            forCellWithReuseIdentifier: "ShopCollectionViewCell"
        )

        refreshDatasource(shops: shops)
    }

    func refreshDatasource(shops: [Shop]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Shop>()
        snapshot.appendSections([.main])
        snapshot.appendItems(shops)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
