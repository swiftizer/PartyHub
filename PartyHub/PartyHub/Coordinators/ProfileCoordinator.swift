//
//  ProfileCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 11.08.2022.
//

import UIKit

final class ProfileCoordinator: Presentable {

    let router = DefaultRouter(with: nil)

    init() {
        (router.toPresent() as? UINavigationController)?.setNavigationBarHidden(false, animated: false)
        start()
    }

    func start() {
        let module = LoginVC()
        module.title = "Profile"
        module.navigation = { [weak self] navType in
            switch navType {
            case .login:
                self?.presentLogin()
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
            case .registration:
                break
//                self?.result?(.success(Void()))
            }

        }
        router.present(nav, animated: true, completion: nil)
    }

    func presentLogin() {
        print("login")
    }

    func toPresent() -> UIViewController {
        return router.toPresent()
    }

}
