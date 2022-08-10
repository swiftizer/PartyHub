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
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        startApp()
        return true
    }

    func startApp() {
        coordinator = .init(tabBarVC: UITabBarController())
        coordinator?.start()
        window?.rootViewController = coordinator?.tabBarVC
        window?.makeKeyAndVisible()
    }
}
