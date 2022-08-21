//
//  AppDelegate.swift
//  PartyHub
//
//  Created by Сергей Николаев on 09.08.2022.
//

import UIKit
import YandexMapsMobile
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: Presentable?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        YMKMapKit.setApiKey("d0ee692b-3897-4784-99ca-0c0896e50e1e")
        YMKMapKit.sharedInstance()
        FirebaseApp.configure()
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
        let menuCordinator = MenuCoordinator()
        let mapCordinator = MapCoordinator()
        let profileCoordinator = ProfileCoordinator()

        // TODO: - убрать force unwrap
        appCoordinator = TabBarCoordinator(with: [
            .init(module: menuCordinator, icon: UIImage(systemName: "list.bullet")!, title: "Menu", tag: 0),
            .init(module: mapCordinator, icon: UIImage(systemName: "map")!, title: "Map", tag: 1),
            .init(module: profileCoordinator, icon: UIImage(systemName: "person.circle")!, title: "Profile", tag: 2)
        ])

        window?.rootViewController = appCoordinator?.toPresent()
        window?.makeKeyAndVisible()
    }
}
