//
//  MapCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 11.08.2022.
//

import UIKit

final class MapCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?

    var navigationController: UINavigationController

    var childCoordinators: [Coordinator] = []

    var type: CoordinatorType { .map }

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
    }

}
