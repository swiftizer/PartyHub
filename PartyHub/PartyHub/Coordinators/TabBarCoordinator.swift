//
//  TabBarCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 10.08.2022.
//

import UIKit

/// Координатор для TabBarControler'а
final class TabBarCoordinator: Coordinator {

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

        tabBarVC.tabBar.backgroundColor = .systemBackground
        tabBarVC.setViewControllers(
            [
                createNavigationControllerFrom(
                    viewController: UIViewController(),
                    title: "menu",
                    image: menuImage
                ),
                createNavigationControllerFrom(
                    viewController: UIViewController(),
                    title: "map",
                    image: mapImage
                ),
                createNavigationControllerFrom(
                    viewController: UIViewController(),
                    title: "person",
                    image: personImage
                )
            ], animated: true
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
        viewController.navigationItem.largeTitleDisplayMode = .always

        let navigationVC = UINavigationController(rootViewController: viewController)
        navigationVC.navigationBar.tintColor = .red
        navigationVC.navigationBar.prefersLargeTitles = true
        navigationVC.tabBarItem = UITabBarItem(title: title, image: image, tag: 1)
        return navigationVC
    }
}
