//
//  NewsViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 20/05/2022.
//

import Foundation
import UIKit

class NewsViewController: UIViewController {
    let _view = NewsView()
    let viewModel: NewsViewModel

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    static let tabBarItem: UITabBarItem = {
        return UITabBarItem(
            title: "Noticias",
            image: UIImage(systemName: "newspaper"),
            selectedImage: UIImage(systemName: "newspaper.fill")
        )
    }()

    init() {
        self.viewModel = NewsViewModel(view: _view)
        super.init(nibName: nil, bundle: nil)
        title = "Noticias"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = _view
    }
}
