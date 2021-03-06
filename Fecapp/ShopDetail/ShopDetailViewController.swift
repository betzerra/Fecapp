//
//  ShopDetailViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 30/04/2022.
//

import Combine
import Foundation
import MapKit
import UIKit

class ShopDetailViewController: UIViewController {
    let shop: Shop
    var shopDetail: ShopDetail?
    private let style: ViewControllerStyle

    let viewModel: ShopDetailViewModel
    let dataSource: ShopsDataSource

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    // Subviews
    private let _view = ShopDetailView()

    private var cancellables = [AnyCancellable]()

    init(shop: Shop, style: ViewControllerStyle, dataSource: ShopsDataSource) {
        self.shop = shop
        self.style = style
        self.viewModel = ShopDetailViewModel(shop: shop, view: _view, style: style)
        self.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)

        viewModel.events
            .receive(on: RunLoop.main)
            .sink { [weak self] events in
                switch events {
                case .openMap(let shop):
                    LogService.info("Opened map: \(shop.title)")
                    self?.openMap(shop: shop)

                case .openMenu(let shop):
                    self?.openMenu(shop: shop)

                case .openInstagram(let username):
                    LogService.info("Opened instagram: \(username)")
                    InstagramHelper.openInstagram(username: username)

                case .openRoaster(let roaster):
                    LogService.info("Opened roaster: \(roaster.title)")
                    self?.openRoaster(roaster)

                case .share(let shop):
                    self?.share(shop: shop)
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

        Task {
            await requestMenu()
        }
    }

    private func requestMenu() async {
        do {
            guard let detail = try await dataSource.fetchShopDetail(slug: shop.slug) else {
                _view.menuButton.isEnabled = false
                return
            }

            shopDetail = detail

            _view.menuButton.isEnabled = detail.menu.count > 0
        } catch {
            _view.menuButton.isEnabled = false
            LogService.logError(error)
        }
    }

    private func openMap(shop: Shop) {
        Task {
            let item = await MapItemSearch.search(shop: shop)

            let region = MKCoordinateRegion(
                center: shop.coordinates.locationCoordinate,
                latitudinalMeters: 300,
                longitudinalMeters: 300
            )

            openMapItem(item, in: region)
        }
    }

    private func openMapItem(_ mapItem: MKMapItem, in region: MKCoordinateRegion) {
        let mapItemName = mapItem.name ?? "N/A"
        LogService.debug("Opening mapItem: \(mapItemName)")

        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
        ]

        mapItem.openInMaps(launchOptions: options)
    }

    private func openMenu(shop: Shop) {
        LogService.info("Opening Menu: \(shop.title)")

        guard let shopDetail = shopDetail else {
            LogService.warning("Tried to open menu but menu wasnt available")
            return
        }

        let vc = ShopMenuViewController(menu: shopDetail.menu)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func openRoaster(_ roaster: Roaster) {
        let roasterShops = dataSource.shops?.filter { $0.roaster == roaster } ?? []
        let vc = RoasterDetailViewController(
            roaster: roaster,
            shops: roasterShops,
            dataSource: dataSource,
            style: style
        )
        navigationController?.pushViewController(vc, animated: true)
    }

    private func share(shop: Shop) {
        guard let url = shop.webURL else {
            return
        }

        let activityViewController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )

        // Fixes crash on iPad
        activityViewController.popoverPresentationController?.sourceView = _view.headView.shareButton

        present(activityViewController, animated: true)
    }
}
