//
//  TabBarCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 10.08.2022.
//

import UIKit
import FirebaseAuth
import Rswift

final class TabBarCoordinator: NSObject, Coordinator {
    var result: ((FlowResult<Void>) -> Void)?
    private let router: TabBarRouter

    init(with items: [TabBarControllerItem]) {
        self.router = .init(with: items.map { $0.module })
        super.init()
        router.container.delegate = self
        items.forEach { (item) in
            item.module.toPresent().tabBarItem = .init(title: item.title, image: item.icon, tag: item.tag)
        }
    }

    func start() {
    }

    func toPresent() -> UIViewController {
        return self.router.toPresent()
    }

}

extension TabBarCoordinator {
    struct TabBarControllerItem {
        let module: Presentable
        let icon: UIImage
        let title: String
        let tag: Int
    }
}

extension TabBarCoordinator: UITabBarControllerDelegate {
    func bounceAnimation(for item: UITabBarItem) {
        guard let imageView = item.value(forKey: "view") as? UIView else { return }
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.1, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        imageView.layer.add(bounceAnimation, forKey: nil)
        FeedbackGenerator.shared.customFeedbackGeneration(.light)
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let item = tabBarController.tabBar.selectedItem else { return }
        bounceAnimation(for: item)
    }

    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        guard let item = tabBarController.tabBar.selectedItem else { return false }
        switch item.tag {
        case 2:
            return userIsLogged()
        default:
            return true
        }
    }

    private func userIsLogged() -> Bool {
        if AuthManager.shared.currentUser() != nil {
            return true
        }
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
        return false
    }
}
