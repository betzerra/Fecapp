//
//  ShopDetailViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Foundation
import UIKit

class ShopDetailViewController: UIViewController {
    let viewModel: ShopDetailViewModel

    // Subviews
    private let headView: ShopHeadView
    private let containerStackView: UIStackView

    init(shop: Shop) {
        self.viewModel = ShopDetailViewModel(shop: shop)

        self.headView = ShopHeadView(viewModel: viewModel)
        self.containerStackView = UIStackView(arrangedSubviews: [headView])

        super.init(nibName: nil, bundle: nil)

        title = viewModel.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground

        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(containerStackView)
    }

    private func setupConstraints() {
        containerStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}
