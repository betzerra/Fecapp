//
//  NewsDetailViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 21/05/2022.
//

import Foundation
import UIKit

class NewsDetailViewController: UIViewController {
    let _view = NewsDetailView()
    let viewModel: NewsDetailViewModel

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    init(summary: NewsSummary, body: String) {
        viewModel = NewsDetailViewModel(view: _view, summary: summary, body: body)

        super.init(nibName: nil, bundle: nil)
        title = summary.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = _view
    }
}
