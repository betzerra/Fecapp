//
//  NewsViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 20/05/2022.
//

import Combine
import Foundation
import UIKit

enum NewsEvent {
    case selectedNews(_ news: NewsSummary, body: String)

    var eventDescription: String {
        switch self {
        case .selectedNews(let news, _):
            return "User selected news: '\(news.title)'"
        }
    }
}

class NewsViewController: UIViewController {
    let _view = NewsView()
    let viewModel: NewsViewModel

    private var cancellables = [AnyCancellable]()

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
        viewModel
            .events
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                LogService.info(event.eventDescription.logMessage)

                switch event {
                case .selectedNews(let summary, let body):
                    let vc = NewsDetailViewController(summary: summary, body: body)
                    self?.navigationController?.pushViewController(vc, animated: true)
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
