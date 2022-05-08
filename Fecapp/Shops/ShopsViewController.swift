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

    var menuItems: [UIAction] {
        [defaultSortAction, sortByLocationAction, filterNeighborhoodsAction]
    }

    lazy var defaultSortAction: UIAction = {
        UIAction(
            title: "Ordenar por default",
            image: UIImage(systemName: "arrow.up.arrow.down")) { [weak self] action in
                self?.dataSource.reset()
            }
    }()

    lazy var sortByLocationAction: UIAction = {
        UIAction(
            title: "Ordenar por proximidad",
            image: UIImage(systemName: "location")) { [weak self] action in
                let filterController = LocationOnboardingViewController()
                let navigationController = UINavigationController(rootViewController: filterController)

                self?.present(navigationController, animated: true)
            }
    }()

    lazy var filterNeighborhoodsAction: UIAction = {
        UIAction(
            title: "Filtrar por barrios",
            image: UIImage(systemName: "building.2")) { [weak self] action in
                guard let dataSource = self?.dataSource else {
                    return
                }

                let filterController = ShopsFilterViewController(dataSource: dataSource)
                let navigationController = UINavigationController(rootViewController: filterController)

                self?.present(navigationController, animated: true)
            }
    }()

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
        let menu = UIMenu(
            title: "Menu",
            image: nil,
            identifier: nil,
            options: [],
            children: menuItems
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "slider.horizontal.3")?.withTintColor(.primary),
            primaryAction: nil,
            menu: menu
        )
    }

    private func pushDetailShop(_ shop: Shop) {
        let controller = ShopDetailViewController(shop: shop)
        navigationController?.pushViewController(controller, animated: true)
    }
}

