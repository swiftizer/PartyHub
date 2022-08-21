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
                    self?.presentAddEvent()
                } else {
                    self?.presentLogin()
                }
            case .description:
                debugPrint("description tapped")
            }
        }
        router.setRootModule(module)
    }

    func presentAddEvent() {
        let module = AddNewEventVC()
        module.title = "Создать мероприятие"
        module.navigation = { [weak self] result in
            switch result {
            case .registration, .back:
                self?.router.popModule(animated: true)
            case .choosePlace:
                // TODO: - Динар разбирается
                self?.presentChoosePlace()
            }
        }

        let nav = UINavigationController(rootViewController: module)
        if #available(iOS 15, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = .systemGray6
            nav.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            nav.navigationBar.backgroundColor = .systemGray6
        }
        nav.navigationBar.tintColor = .label
        nav.modalPresentationStyle = .overFullScreen

        self.router.present(nav, animated: true, completion: nil)
    }

    func presentChoosePlace() {
        let module = MapToChooseVC()
        module.title = "Карта"
//        module.navigation = {
//
//        }
        router.push(module, animated: true)
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
