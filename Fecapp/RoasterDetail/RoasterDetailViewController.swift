//
//  RoasterDetailViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 19/05/2022.
//

import Foundation
import UIKit

class RoasterDetailViewController: UIViewController {
    private let viewModel: RoasterDetailViewModel

    // Subviews
    private let _view = RoasterDetailView()

    init(roaster: Roaster, shops: [Shop]) {
        viewModel = RoasterDetailViewModel(roaster: roaster, shops: shops, view: _view)

        super.init(nibName: nil, bundle: nil)
        title = roaster.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = _view
    }
}
