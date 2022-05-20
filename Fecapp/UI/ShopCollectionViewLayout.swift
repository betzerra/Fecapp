//
//  ShopCollectionViewLayout.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 20/05/2022.
//

import Foundation
import UIKit

// UI Constants
private let cellVerticalPadding: CGFloat = 8.0
private let cellHorizontalPadding: CGFloat = 16.0

class ShopCollectionViewLayout {
    enum Size {
        case small, medium
    }

    private var columns: Int {
        let scenes = UIApplication.shared.connectedScenes

        guard let windowScene = scenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return UIScreen.main.traitCollection.horizontalSizeClass == .regular ? 2 : 1
        }

        return ShopCollectionViewLayout.columns(
            bounds: window.bounds,
            size: self.size
        )
    }

    let size: Size
    let supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem]

    init(size: Size, supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []) {
        self.size = size
        self.supplementaryItems = supplementaryItems
    }

    func layout() -> UICollectionViewCompositionalLayout {
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
            heightDimension: .estimated(Self.cellHeight(size: self.size))
        )

        let groupLayout = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: itemLayout,
            count: columns
        )

        let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
        sectionLayout.boundarySupplementaryItems = supplementaryItems

        let layout = UICollectionViewCompositionalLayout(section: sectionLayout)
        return layout
    }

    static func columns(bounds: CGRect, size: Size) -> Int {
        switch size {
        case .small:
            switch bounds.width {
            case 0..<450:
                return 2

            case 450..<900:
                return 3

            default:
                return 4
            }

        case .medium:
            switch bounds.width {
            case 0..<450:
                return 1

            case 450..<900:
                return 2

            default:
                return 3
            }
        }
    }

    static func cellHeight(size: Size) -> CGFloat {
        switch size {
        case .small:
            return 70

        case .medium:
            return 100
        }
    }
}
