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
        rootModule.title = "Мероприятия поблизости"
        rootModule.adapter.navigation = { [weak self] navType in
            switch navType {
            case .addEvent:
                if AuthManager.shared.currentUser() != nil {
                    FeedbackGenerator.shared.customFeedbackGeneration(.medium)
                    self?.presentAddEvent()
                } else {
                    FeedbackGenerator.shared.errorFeedbackGenerator()
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
            case .success:
                self?.rootModule.loadData()
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
