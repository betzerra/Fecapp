//
//  ShopsViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import Combine
import CoreLocation
import UIKit

class ShopsViewController: UIViewController {
    private let locationManager = LocationManager()
    private let dataSource: ShopsDataSource

    private let _view = ShopsView()
    private var viewModel: ShopsViewModel

    private var cancellables = [AnyCancellable]()

    static let tabBarItem: UITabBarItem = {
        return UITabBarItem(
            title: "Cafeterías",
            image: UIImage(systemName: "cup.and.saucer"),
            selectedImage: nil)
    }()

    var menuItems: [UIAction] {
        [defaultSortAction, sortByLocationAction, filterNeighborhoodsAction]
    }

    lazy var defaultSortAction: UIAction = {
        UIAction(
            title: "Ordenar por default",
            image: UIImage(systemName: "arrow.up.arrow.down")) { [weak self] action in
                LogService.info("Tapped 'sort by default'")
                self?.dataSource.reset()
            }
    }()

    lazy var sortByLocationAction: UIAction = {
        UIAction(
            title: "Ordenar por proximidad",
            image: UIImage(systemName: "location")) { [weak self] action in
                LogService.info("Tapped 'sort by location'")
                guard let locationManager = self?.locationManager else {
                    return
                }

                switch locationManager.fetchAuthorizationStatus() {
                case .authorizedWhenInUse, .authorizedAlways, .authorized:
                    locationManager.requestLocation()

                case .restricted, .notDetermined, .denied:
                    self?.showLocationOnboarding()

                @unknown default:
                    assertionFailure("@unknown default")
                }
            }
    }()

    lazy var filterNeighborhoodsAction: UIAction = {
        UIAction(
            title: "Filtrar por barrios",
            image: UIImage(systemName: "building.2")) { [weak self] action in
                LogService.info("Tapped 'neighborhood filter'")

                guard let dataSource = self?.dataSource else {
                    return
                }

                let filterController = ShopsFilterViewController(dataSource: dataSource)
                let navigationController = UINavigationController(rootViewController: filterController)

                self?.present(navigationController, animated: true)
            }
    }()

    init(dataSource: ShopsDataSource) {
        self.dataSource = dataSource
        viewModel = ShopsViewModel(view: _view, dataSource: dataSource)
        super.init(nibName: nil, bundle: nil)

        self.title = "Cafeterías"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = _view
        setupNavigationItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.events
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case .shopSelected(let shop):
                    LogService.info("Selected '\(shop.title)'")
                    self?.pushDetailShop(shop)
                }
            }
            .store(in: &cancellables)

        locationManager.$lastLocation
            .receive(on: RunLoop.main)
            .sink { [weak self] location in
                guard let location = location else {
                    return
                }

                self?.viewModel.sortByNearestLocation(location)
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

    private func showLocationOnboarding() {
        let controller = LocationOnboardingViewController(locationManager: locationManager)
        let navigationController = UINavigationController(rootViewController: controller)
        present(navigationController, animated: true)
    }
}

