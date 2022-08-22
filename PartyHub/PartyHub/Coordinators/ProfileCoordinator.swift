//
//  ProfileCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 11.08.2022.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    var result: ((FlowResult<Void>) -> Void)?
    let router = DefaultRouter(with: nil)

    init() {
        (router.toPresent() as? UINavigationController)?.setNavigationBarHidden(false, animated: false)
        start()
    }

    func start() {
        let module = ProfileVC()
        module.title = "Profile"
        module.navigation = { navType in
            switch navType {
            case .exit:
                break
            }
        }
        router.setRootModule(module)
    }

    func toPresent() -> UIViewController {
        return router.toPresent()
    }
}
