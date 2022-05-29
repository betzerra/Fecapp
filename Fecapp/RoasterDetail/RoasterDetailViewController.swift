//
//  RoasterDetailViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 19/05/2022.
//

import Combine
import Foundation
import UIKit

class RoasterDetailViewController: UIViewController {
    private let dataSource: ShopsDataSource
    private let style: ViewControllerStyle
    private let viewModel: RoasterDetailViewModel

    private var navigationBarWasHidden: Bool?

    private var cancellables = [AnyCancellable]()

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    // Subviews
    private let _view = RoasterDetailView()

    init(
        roaster: Roaster,
        shops: [Shop],
        dataSource: ShopsDataSource,
        style: ViewControllerStyle
    ) {
        self.dataSource = dataSource
        self.style = style
        viewModel = RoasterDetailViewModel(roaster: roaster, shops: shops, view: _view)

        super.init(nibName: nil, bundle: nil)
        title = roaster.title

        viewModel.events.sink { [weak self] event in
            switch event {
            case .openInstagram(let username):
                LogService.info("Opened instagram: \(username)")
                InstagramHelper.openInstagram(username: username)

            case .selectedShop(let shop):
                LogService.info("Shop selected: \(shop.title)")
                self?.openShop(shop)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarWasHidden = navigationController?.navigationBar.isHidden
        navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let navigationBarWasHidden = navigationBarWasHidden {
            navigationController?.navigationBar.isHidden = navigationBarWasHidden
        }
    }

    private func openShop(_ shop: Shop) {
        guard style == .fullscreen else {
            return
        }

        let controller = ShopDetailViewController(
            shop: shop,
            style: .fullscreen,
            dataSource: dataSource
        )

        navigationController?.pushViewController(controller, animated: true)
    }
}
