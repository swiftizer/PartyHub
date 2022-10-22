//
//  MapCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 11.08.2022.
//

import UIKit

final class MapCoordinator: Coordinator {
    var result: ((FlowResult<Void>) -> Void)?
    let router = DefaultRouter(with: nil)
    let rootModule = MapVC()

    init() {
        (router.toPresent() as? UINavigationController)?.setNavigationBarHidden(false, animated: false)
        start()
    }

    func start() {
        rootModule.title = "Карта"
        rootModule.navigation = { [weak self] result in
            switch result {
            case .description(event: let event):
                self?.presentEventDescription(event)
            }
        }
        router.setRootModule(rootModule)
    }

    func presentEventDescription(_ event: Event) {
        let module = EventVC(event: event)
        module.navigation = { [weak self] result in
            switch result {
            case .back:
                self?.router.popModule(animated: true)
            case .go:
                if AuthManager.shared.currentUser() == nil {
                    self?.router.popModule(animated: true)
                    self?.presentLogin()
                }
            }
        }

        router.push(module, animated: true)
    }

    func presentLogin() {
        let authCoordinator = AuthRegCoordinator()
        authCoordinator.result = { [weak self] res in
            switch res {
            case .success:
                self?.router.popModule(animated: true)
            case .canceled:
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
