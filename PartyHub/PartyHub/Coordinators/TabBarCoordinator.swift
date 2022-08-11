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

        let menuCoordinator = MenuCoordinator(with: .init(title: "Menu", image: menuImage), isloggedin: isLoggedIn)
        let mapCoordinator = MapCoordinator(with: .init(title: "Map", image: mapImage), isloggedin: isLoggedIn)
        let profileCoordinator = ProfileCoordinator(with: .init(
            title: "Profile",
            image: personImage),
            isloggedin: isLoggedIn
        )

        tabBarVC.tabBar.backgroundColor = .secondarySystemBackground
        tabBarVC.setViewControllers([
            menuCoordinator.start(UIViewController()),
            mapCoordinator.start(UIViewController()),
            profileCoordinator.start(UIViewController())
        ], animated: false)
    }
}
