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
        module.title = "Профиль"
        module.navigation = { result in
            switch result {
            case .exit:
                AuthManager.shared.signOut { result in
                    switch result {
                    case .success:
                        FeedbackGenerator.shared.customFeedbackGeneration(.medium)
                        NotificationCenter.default.post(name: NSNotification.Name("AuthManager.SignOut.Sirius.PartyHub"), object: nil)
                        module.tabBarController?.selectedIndex = 0
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                    }
                }
            case .removeAccount:
                AuthManager.shared.deleteAccount { result in
                    switch result {
                    case .success:
                        FeedbackGenerator.shared.succesFeedbackGenerator()
                        module.tabBarController?.selectedIndex = 0
                    case .failure:
                        FeedbackGenerator.shared.errorFeedbackGenerator()
                    }
                }
            }
        }
        // MARK: - Приплыли... По хорошему сделать отдельный координатор
        module.createdEventsVC.adapter.navigation = { [weak self] result in
            switch result {
            case .description(event: let event):
                self?.presentDescrption(event: event)
            default:
                break
            }
        }
        module.favoriteEventsVC.adapter.navigation = { [weak self] result in
            switch result {
            case .description(event: let event):
                self?.presentDescrption(event: event)
            default:
                break
            }
        }
        router.setRootModule(module)
    }

    func presentDescrption(event: Event) {
        let module = EventVC(event: event)
        module.navigation = { [weak self] result in
            switch result {
            case .back:
                NotificationCenter.default.post(name: NSNotification.Name("ProfileCoordinator.PresentDescrption.Back.Sirius.PartyHub"), object: nil)
                self?.router.popModule(animated: true)
            case .go:
                break
            }
        }
        let nav = UINavigationController(rootViewController: module)
        nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.tintColor = .label
        nav.modalPresentationStyle = .overFullScreen
        router.present(nav, animated: true, completion: nil)
    }

    func toPresent() -> UIViewController {
        return router.toPresent()
    }
}
