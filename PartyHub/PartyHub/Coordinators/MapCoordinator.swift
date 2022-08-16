//
//  MapCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 11.08.2022.
//

import UIKit

final class MapCoordinator: Presentable {

    let router = DefaultRouter(with: nil)

    init() {
        (router.toPresent() as? UINavigationController)?.setNavigationBarHidden(false, animated: false)
        start()
    }

    func start() {
        let module = MapVC()
        module.title = "Map"
        router.setRootModule(module)
    }

    func toPresent() -> UIViewController {
        return router.toPresent()
    }

}
