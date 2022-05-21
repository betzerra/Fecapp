//
//  SceneDelegate.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UITabBarControllerDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let tabBarController = InitialScreen.tabBarController()
        tabBarController.delegate = self

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()

        // Fixes issue where translucent bar glitched after going
        // back in MapView (iOS 15)
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()

        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func tabBarControllerSupportedInterfaceOrientations(
        _ tabBarController: UITabBarController
    ) -> UIInterfaceOrientationMask {
        return tabBarController.inferredSupportedInterfaceOrientations ?? .portrait
    }
}

protocol InferredSupportedInterfaceOrientations {
    var inferredSupportedInterfaceOrientations: UIInterfaceOrientationMask? { get }
}

extension UINavigationController: InferredSupportedInterfaceOrientations {
    var inferredSupportedInterfaceOrientations: UIInterfaceOrientationMask? {
        guard let topViewController = topViewController else {
            return .portrait
        }

        guard let presentedViewController = topViewController.presentedViewController else {
            return topViewController.supportedInterfaceOrientations
        }

        // swiftlint:disable:next line_length
        if let presentedViewController = topViewController.presentedViewController as? InferredSupportedInterfaceOrientations {
            return presentedViewController.inferredSupportedInterfaceOrientations
        } else {
            return presentedViewController.supportedInterfaceOrientations
        }
    }
}

extension UITabBarController: InferredSupportedInterfaceOrientations {
    var inferredSupportedInterfaceOrientations: UIInterfaceOrientationMask? {
        guard let controller = selectedViewController as? InferredSupportedInterfaceOrientations else {
            return .portrait
        }

        return controller.inferredSupportedInterfaceOrientations
    }
}
