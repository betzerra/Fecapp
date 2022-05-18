//
//  MapViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 10/05/2022.
//

import Foundation
import Combine
import UIKit

class MapViewController: UIViewController {
    let dataSource: ShopsDataSource
    let viewModel: MapViewModel

    private let _view = MapView()
    private var cancellables = [AnyCancellable]()

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .all
    }

    static let tabBarItem: UITabBarItem = {
        return UITabBarItem(
            title: "Mapa",
            image: UIImage(systemName: "map"),
            selectedImage: UIImage(systemName: "map.fill")
        )
    }()

    init(dataSource: ShopsDataSource) {
        self.dataSource = dataSource
        self.viewModel = MapViewModel(dataSource: dataSource, view: _view)
        super.init(nibName: nil, bundle: nil)

        viewModel.events
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                guard let self = self else {
                    return
                }

                switch event {
                case.selected(let shop):
                    let controller = ShopDetailViewController(
                        shop: shop,
                        style: .sheet,
                        dataSource: self.dataSource
                    )

                    // Avoid showing empty space on navigation bar for card
                    let navigationController = UINavigationController(rootViewController: controller)
                    navigationController.navigationBar.isHidden = true

                    // Set "card" properties
                    if let sheet = navigationController.sheetPresentationController {
                        sheet.detents = [.medium(), .large()]
                        sheet.prefersGrabberVisible = true
                    }

                    self.present(navigationController, animated: true)
                }
            }
            .store(in: &cancellables)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = _view
    }
}
