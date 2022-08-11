//
//  AppDelegate.swift
//  PartyHub
//
//  Created by Сергей Николаев on 09.08.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: TabBarCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if #available(iOS 15, *) {
            UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
            UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
        }
        startApp()
        return true
    }

    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }
}

extension AppDelegate {

    // MARK: - Private Methods

    private func startApp() {
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        coordinator = .init(tabBarVC: UITabBarController())
        coordinator?.start()
        window?.rootViewController = coordinator?.tabBarVC
        window?.makeKeyAndVisible()
    }
}
