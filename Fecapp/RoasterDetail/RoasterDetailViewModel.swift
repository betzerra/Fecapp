//
//  RoasterDetailViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 19/05/2022.
//

import Combine
import Foundation
import UIKit

enum RoasterDetailViewModelEvent {
    case openInstagram(username: String)
}

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

                cell.titleLabel.text = shop.title
                cell.titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
                cell.subtitleLabel.isHidden = true

                if let constraint = cell.horizontalSpacingConstraint {
                    constraint.constant = 8
                }

                if let thumbnail = shop.thumbnail?.small {
                    cell.imageView.sd_setImage(with: thumbnail)
                }

                return cell
            })

        dataSource.supplementaryViewProvider = { [weak self](collectionView, kind, indexPath) in
            guard let self = self else { return nil }

            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "header",
                for: indexPath) as? RoasterHeaderView else {
                return nil
            }

            headerView.instagramButton.setAttributedTitle(self.attributedInstagram, for: .normal)
            headerView.shippingLabel.isHidden = !self.roaster.shipsOutsideCABA
            headerView.coffeeShopsLabel.text = self.coffeeShopsTitle
            headerView.instagramButton.addAction(self.instagramAction, for: .touchUpInside)
            return headerView
        }

        return dataSource
    }()

    var attributedInstagram: NSAttributedString {
        guard let linkImage = UIImage(named: "instagram", in: Bundle.main, with: nil) else {
            return NSAttributedString(string: roaster.instagram)
        }

        return NSAttributedString(string: roaster.instagram, leadingImage: linkImage)
    }

    var coffeeShopsTitle: String {
        switch shops.count {
        case 0:
            return "Ninguna cafetería que conozcamos usa el café de \(roaster.title)"

        case 1:
            return "Una cafetería usa el café de \(roaster.title)"

        default:
            return "\(shops.count) cafeterías usan el café de \(roaster.title)"
        }
    }

    var instagramAction: UIAction {
        UIAction { [weak self] _ in
            guard let username = self?.roaster.instagram else {
                return
            }

            self?.events.send(.openInstagram(username: username))
        }
    }

    let view: RoasterDetailView

    let roaster: Roaster
    let shops: [Shop]
    let events = PassthroughSubject<RoasterDetailViewModelEvent, Never>()

    init(roaster: Roaster, shops: [Shop], view: RoasterDetailView) {
        self.roaster = roaster
        self.shops = shops
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
