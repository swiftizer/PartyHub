//
//  TabBarCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 10.08.2022.
//

import UIKit

/// Координатор для TabBarControler'а
final class TabBarCoordinator: TabBarCoordinatorProtocol {

    // MARK: - Public Properties

    public var tabBarVC: UITabBarController
    public var isLoggedIn: Bool = false

    // MARK: - Initialization

    init(tabBarVC: UITabBarController) {
        self.tabBarVC = tabBarVC
    }

    // MARK: - Public Methods

    public func start() {
        showMain()
    }

    public func showMain() {
        guard let menuImage = UIImage(systemName: "list.bullet"),
              let mapImage = UIImage(systemName: "map"),
              let personImage = UIImage(systemName: "person.circle")
        else { return }

        tabBarVC.tabBar.backgroundColor = .secondarySystemBackground
        tabBarVC.setViewControllers(
            [
                createNavigationControllerFrom(
                    viewController: UIViewController(),
                    title: "Menu",
                    image: menuImage
                ),
                createNavigationControllerFrom(
                    viewController: UIViewController(),
                    title: "Map",
                    image: mapImage
                ),
                createNavigationControllerFrom(
                    viewController: UIViewController(),
                    title: "Profile",
                    image: personImage
                )
            ], animated: false
        )
    }
}

extension TabBarCoordinator {

    // MARK: - Private Methods

    private func createNavigationControllerFrom(
        viewController: UIViewController,
        title: String,
        image: UIImage
    ) -> UIViewController {
        viewController.title = title

        let navigationVC = UINavigationController(rootViewController: viewController)
        navigationVC.navigationBar.prefersLargeTitles = false
        navigationVC.tabBarItem = UITabBarItem(title: title, image: image, tag: 1)
        return navigationVC
    }
}
