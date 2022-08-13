//
//  MenuCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 11.08.2022.
//

import UIKit

final class MenuCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?

    var navigationController: UINavigationController

    var childCoordinators: [Coordinator] = []

    var type: CoordinatorType { .menu }

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
    }
}
