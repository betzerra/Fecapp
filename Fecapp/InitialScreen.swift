//
//  InitialTabBarController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 20/05/2022.
//

import Foundation
import UIKit

class InitialScreen {
    static func tabBarController() -> UITabBarController {
        // Location Manager
        let locationManager = LocationManager()

        // Creating ShopsDataSource so it can be used by 1st and 2nd screen
        let dataSource = ShopsDataSource(locationManager: locationManager)

        let viewControllers = [
            Self.shopsViewController(dataSource: dataSource),
            Self.mapViewController(dataSource: dataSource),
            Self.newsViewController()
        ]

        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(viewControllers, animated: false)
        return tabBarController
    }

    private static func shopsViewController(dataSource: ShopsDataSource) -> UIViewController {
        let shopsController = ShopsViewController(dataSource: dataSource)
        let navigationController = UINavigationController(rootViewController: shopsController)
        navigationController.tabBarItem = ShopsViewController.tabBarItem
        return navigationController
    }

    private static func mapViewController(dataSource: ShopsDataSource) -> UIViewController {
        let mapController = MapViewController(dataSource: dataSource)
        let navigationController = UINavigationController(rootViewController: mapController)
        navigationController.tabBarItem = MapViewController.tabBarItem
        return navigationController
    }

    private static func newsViewController() -> UIViewController {
        let controller = NewsViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.tabBarItem = NewsViewController.tabBarItem
        return navigationController
    }
}
