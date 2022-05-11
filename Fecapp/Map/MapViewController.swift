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

    static let tabBarItem: UITabBarItem = {
        return UITabBarItem(
            title: "Mapa",
            image: UIImage(systemName: "map"),
            selectedImage: nil)
    }()

    init(dataSource: ShopsDataSource) {
        self.dataSource = dataSource
        self.viewModel = MapViewModel(dataSource: dataSource, view: _view)
        super.init(nibName: nil, bundle: nil)

        viewModel.events
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case.selected(let shop):
                    let controller = ShopDetailViewController(shop: shop)
                    self?.navigationController?.pushViewController(controller, animated: true)
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
