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
    private let dataSource: ShopsDataSource

    private var previousWindowBounds: CGRect?

    private let _view = ShopsView()
    private var viewModel: ShopsViewModel

    private var cancellables = [AnyCancellable]()

    private var searchController = UISearchController(searchResultsController: nil)

    static let tabBarItem: UITabBarItem = {
        return UITabBarItem(
            title: "Cafeterías",
            image: UIImage(systemName: "cup.and.saucer"),
            selectedImage: UIImage(systemName: "cup.and.saucer.fill")
        )
    }()

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .allButUpsideDown
    }

    var menuItems: [UIAction] {
        [defaultSortAction, sortByLocationAction, filterNeighborhoodsAction]
    }

    lazy var defaultSortAction: UIAction = {
        UIAction(
            title: "Ordenar por default",
            image: UIImage(systemName: "arrow.up.arrow.down")) { [weak self] _ in
                LogService.info("Tapped 'sort by default'")
                self?.dataSource.sort = .rank
        }
    }()

    lazy var sortByLocationAction: UIAction = {
        UIAction(
            title: "Ordenar por proximidad",
            image: UIImage(systemName: "location")) { [weak self] _ in
                LogService.info("Tapped 'sort by location'")
                guard let locationManager = self?.dataSource.locationManager else {
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

                self?.dataSource.sort = .location
        }
    }()

    lazy var filterNeighborhoodsAction: UIAction = {
        UIAction(
            title: "Filtrar por barrios",
            image: UIImage(systemName: "building.2")) { [weak self] _ in
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

        configureSearchController()

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
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let currentBounds = view.window?.bounds,
           let previousWindowBounds = previousWindowBounds, currentBounds != previousWindowBounds {
            _view.refreshLayout()
        }

        previousWindowBounds = view.window?.bounds
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
            image: UIImage(systemName: "slider.horizontal.3")?.withTintColor(.accent),
            primaryAction: nil,
            menu: menu
        )
    }

    private func pushDetailShop(_ shop: Shop) {
        let controller = ShopDetailViewController(
            shop: shop,
            style: .fullscreen,
            dataSource: dataSource
        )
        navigationController?.pushViewController(controller, animated: true)
    }

    private func showLocationOnboarding() {
        let controller = LocationOnboardingViewController(locationManager: dataSource.locationManager)
        let navigationController = UINavigationController(rootViewController: controller)
        present(navigationController, animated: true)
    }
}

extension ShopsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        dataSource.search(with: searchController.searchBar.text)
    }

    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Buscar"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}
