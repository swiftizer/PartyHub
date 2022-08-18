//
//  AuthRegCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 18.08.2022.
//

import UIKit

final class AuthRegCoordinator: Presentable {
    typealias Result = Void
    let router = DefaultRouter(with: nil)
    var result: ((FlowResult<Void>) -> Void)?

    init() {
        (router.toPresent() as? UINavigationController)?.setNavigationBarHidden(false, animated: false)
        start()
    }

    func start() {
        let module = LoginVC()
        module.title = "Login"
        module.navigation = { [weak self] navType in
            switch navType {
            case .enter:
                self?.result?(.success(Void()))
            case .register:
                self?.presentRegistration()
            }
        }
        router.setRootModule(module)
    }

    func presentRegistration() {
        let module = RegistrationVC()
        module.title = "Registration"
        let nav = UINavigationController(rootViewController: module)
        nav.modalPresentationStyle = .overFullScreen
        module.navigation = { [weak self] typeNav in
            switch typeNav {
            case .back:
                self?.router.popModule(animated: true)
            case .enter:
                print("registration")
                self?.result?(.success(Void()))
            }

        }
        router.present(nav, animated: true, completion: nil)
    }

    func toPresent() -> UIViewController {
        return router.toPresent()
    }
}
