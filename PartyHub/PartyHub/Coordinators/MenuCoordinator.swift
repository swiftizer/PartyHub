//
//  MenuCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 11.08.2022.
//

import UIKit

final class MenuCoordinator: Coordinator {
    var result: ((FlowResult<Void>) -> Void)?

    let router = DefaultRouter(with: nil)

    init() {
        (router.toPresent() as? UINavigationController)?.setNavigationBarHidden(false, animated: false)
        start()
    }

    func start() {
        let module = MenuVC()
        module.title = "Menu"
        module.adapter.navigation = { [weak self] navType in
            switch navType {
            case .addEvent:
                if AuthManager.shared.currentUser() != nil {
                    print("present add event vc")
                } else {
                    self?.presentLogin()
                }
            case .description:
                debugPrint("description tapped")
            }
        }
        router.setRootModule(module)
    }

    func presentLogin() {
        let authCoordinator = AuthRegCoordinator()
        authCoordinator.result = { [weak self] res in
            switch res {
            case .success, .canceled:
                self?.router.popModule(animated: true)
            default :
                break
            }
        }
        router.present(authCoordinator, animated: true, completion: nil)
    }

    func toPresent() -> UIViewController {
        return router.toPresent()
    }

}
