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

        scrollToTopHack()
    }

    /// Horrible hack to scroll to top on UITextView
    private func scrollToTopHack() {
        _view.textView.isScrollEnabled = false
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        _view.textView.scrollRectToVisible(rect, animated: false)
        _view.textView.isScrollEnabled = true
    }
}
