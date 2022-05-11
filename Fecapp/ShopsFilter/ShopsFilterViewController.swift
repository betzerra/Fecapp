//
//  ShopsFilterViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Foundation
import UIKit

class ShopsFilterViewController: UIViewController {
    private let _view = ShopsFilterView()
    let viewModel: ShopsFilterViewModel

    init(dataSource: ShopsDataSource) {
        viewModel = ShopsFilterViewModel(view: _view, dataSource: dataSource)

        super.init(nibName: nil, bundle: nil)
        title = "Filtrar"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = _view
    }
}
