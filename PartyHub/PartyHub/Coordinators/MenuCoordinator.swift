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
    let rootModule = MenuVC()

    init() {
        (router.toPresent() as? UINavigationController)?.setNavigationBarHidden(false, animated: false)
        start()
    }

    func start() {
        rootModule.title = "Menu"
        rootModule.adapter.navigation = { [weak self] navType in
            switch navType {
            case .addEvent:
                if AuthManager.shared.currentUser() != nil {
                    self?.presentAddEvent()
                } else {
                    self?.presentLogin()
                }
            case .description(event: let event):
                self?.presentDescription(event: event)
            }
        }
        router.setRootModule(rootModule)
    }

    func presentDescription(event: Event) {
        let module = EventVC(event: event)
        let nav = UINavigationController(rootViewController: module)
        nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.tintColor = .label
        nav.modalPresentationStyle = .overFullScreen
        module.navigation = { [weak self] result in
            switch result {
            case .back:
                self?.router.popModule(animated: true)
            case .go:
                print("press GO in Menu Coordinator")
            }
        }
        router.present(nav, animated: true, completion: nil)
    }

    func presentAddEvent() {
        let addNewEventCoordinator = AddNewEventCoordinator()
        addNewEventCoordinator.result = { [weak self] result in
            switch result {
            case .success:
                self?.rootModule.loadData()
                self?.router.popModule(animated: true)
            case .canceled:
                self?.router.popModule(animated: true)
            default:
                break
            }
        }
        router.present(addNewEventCoordinator, animated: true, completion: nil)
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
