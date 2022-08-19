//
//  MenuCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 11.08.2022.
//

import UIKit

final class MenuCoordinator: Presentable {

    let router = DefaultRouter(with: nil)

    init() {
        (router.toPresent() as? UINavigationController)?.setNavigationBarHidden(false, animated: true)
        start()
    }

    func start() {
        let module = MenuVC()
        module.title = "Menu"
        router.setRootModule(module)
    }

    func toPresent() -> UIViewController {
        return router.toPresent()
    }

}
