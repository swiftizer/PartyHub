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
    private var appCoordinator: Presentable?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
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

        let menuCordinator = MenuCoordinator()
        menuCordinator.start()
        let mapCordinator = MapCoordinator()
        mapCordinator.start()
        let profileCordinator = AuthRegCoordinator()
        profileCordinator.start()

        appCoordinator = TabBarCoordinator(with: [
            .init(module: menuCordinator, icon: UIImage(systemName: "list.bullet")!, title: "Menu", tag: 0),
            .init(module: mapCordinator, icon: UIImage(systemName: "map")!, title: "Map", tag: 1),
            .init(module: profileCordinator, icon: UIImage(systemName: "person.circle")!, title: "Profile", tag: 2)
        ])

        window?.rootViewController = appCoordinator?.toPresent()
        window?.makeKeyAndVisible()
    }
}
