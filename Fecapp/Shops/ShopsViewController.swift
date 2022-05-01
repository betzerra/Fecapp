//
//  ShopsViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import Combine
import UIKit

class ShopsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    let dataSource = ShopsDataSource()

    var viewModel: ShopsViewModel!

    var cancellables = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()

        viewModel = ShopsViewModel(collectionView: collectionView, dataSource: dataSource)

        viewModel.events
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case .shopSelected(let shop):
                    self?.pushDetailShop(shop)
                }
            }
            .store(in: &cancellables)
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

    private func pushDetailShop(_ shop: Shop) {
        let controller = ShopDetailViewController(shop: shop)
        navigationController?.pushViewController(controller, animated: true)
    }
}

