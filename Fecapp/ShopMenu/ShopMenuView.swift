//
//  ShopMenuView.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 18/05/2022.
//

import Foundation
import UIKit

class ShopMenuView: UIView {
    let collectionView: UICollectionView

    init() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: ShopMenuView.createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)

        collectionView.loadInto(containerView: self)
        backgroundColor = .systemBackground

        collectionView.register(
           SectionReusableView.self,
           forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
           withReuseIdentifier: "section"
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func createLayout() -> UICollectionViewLayout {
        // swiftlint:disable:next line_length
        let sectionProvider = { (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var section: NSCollectionLayoutSection

            var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            listConfiguration.headerMode = .supplementary

            section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
            return section
        }

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}
