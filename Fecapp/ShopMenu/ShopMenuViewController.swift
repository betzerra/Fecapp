//
//  ShopMenuViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 18/05/2022.
//

import Foundation
import UIKit

class ShopMenuViewController: UIViewController {
    let viewModel: ShopMenuViewModel

    private let _view = ShopMenuView()
    private var navigationBarWasHidden: Bool?

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    init(menu: [ShopMenuCategory]) {
        self.viewModel = ShopMenuViewModel(view: _view, menu: menu)

        super.init(nibName: nil, bundle: nil)

        title = "Menu"
    }

    override func loadView() {
        super.loadView()
        view = _view
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}
