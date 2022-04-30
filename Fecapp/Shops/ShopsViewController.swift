//
//  ShopsViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import UIKit

class ShopsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    let dataSource = ShopsDataSource()

    var viewModel: ShopsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()

        viewModel = ShopsViewModel(collectionView: collectionView, dataSource: dataSource)
    }

    private func setupNavigationItem() {
        let filterAction = UIAction { [weak self] _ in
            guard let dataSource = self?.dataSource else {
                return
            }

            let filterController = ShopsFilterViewController(dataSource: dataSource)
            let navigationController = UINavigationController(rootViewController: filterController)

            self?.present(navigationController, animated: true)
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "slider.horizontal.3")?.withTintColor(.primary),
            primaryAction: filterAction,
            menu: nil
        )
    }
}

