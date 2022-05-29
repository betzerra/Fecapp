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
    private let viewModel: RoasterDetailViewModel

    private var navigationBarWasHidden: Bool?

    private var cancellables = [AnyCancellable]()

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    // Subviews
    private let _view = RoasterDetailView()

    init(roaster: Roaster, shops: [Shop]) {
        viewModel = RoasterDetailViewModel(roaster: roaster, shops: shops, view: _view)

        super.init(nibName: nil, bundle: nil)
        title = roaster.title

        viewModel.events.sink { event in
            switch event {
            case .openInstagram(let username):
                LogService.info("Opened instagram: \(username)")
                InstagramHelper.openInstagram(username: username)
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
}
