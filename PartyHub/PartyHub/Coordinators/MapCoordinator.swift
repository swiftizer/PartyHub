//
//  MapCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 11.08.2022.
//

import UIKit

/// Координатор MapCoordinator'a
final class MapCoordinator: PresentableProtocol {

    // MARK: - Private Properties

    private let model: TabBarItemModel

    // MARK: - Initialization

    init(with model: TabBarItemModel, isloggedin: Bool) {
        self.model = model
    }

    // MARK: - Public Properties

    public func start(_ viewController: UIViewController) -> UINavigationController {
        let navigationVC = UINavigationController(rootViewController: viewController)
        viewController.title = model.title
        navigationVC.navigationBar.prefersLargeTitles = false
        navigationVC.tabBarItem = UITabBarItem(title: model.title, image: model.image, tag: 1)
        return navigationVC
    }
}
