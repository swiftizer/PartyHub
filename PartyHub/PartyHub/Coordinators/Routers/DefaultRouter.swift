//
//  DefaultRouter.swift
//  PartyHub
//
//  Created by Dinar Garaev on 16.08.2022.
//

import UIKit

/// роутер дефолтных VC'ов
final class DefaultRouter: Presentable {
    enum DeliveryKind {
        case root(Presentable)
        case push(Presentable)
        case modal(Presentable)
    }

    private let container: UINavigationController
    private(set) var modules: [DeliveryKind] = []

    init(with rootModule: Presentable?) {
        if let root = rootModule {
            self.modules = [.root(root)]
            self.container = UINavigationController(rootViewController: root.toPresent())
        } else {
            self.container = UINavigationController(rootViewController: UIViewController())
        }
        configure()
    }

    func configure() {
        if #available(iOS 15, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = .systemGray6
            container.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            container.navigationBar.backgroundColor = .systemGray6
        }
    }

    func toPresent() -> UIViewController {
        return container
    }

    func removeLastModule() {
        modules.removeLast()
    }

    func present(_ module: Presentable, animated: Bool, isModalInPresentation: Bool = true, completion: (() -> Void)?) {
        if #available(iOS 13.0, *) {
            module.toPresent().isModalInPresentation = isModalInPresentation
        }

        container.present(module.toPresent(), animated: animated, completion: completion)
        modules.append(.modal(module))
    }

    func push(_ module: Presentable, animated: Bool) {
        container.pushViewController(module.toPresent(), animated: animated)
        modules.append(.push(module))
    }

    func setRootModule(_ module: Presentable) {
        container.viewControllers = [module.toPresent()]
        modules = [.root(module)]
    }

    func popModule(animated: Bool) {
        guard let lastModule = self.modules.last else {
            return
        }

        switch lastModule {
        case .root:
            break
        case .push:
            self.container.popViewController(animated: animated)
            self.modules.removeLast()
        case .modal(let module):
            module.toPresent().dismiss(animated: animated, completion: nil)
            self.modules.removeLast()
        }
    }

    func insert(module: Presentable, at index: Int) {
        var viewControllers = self.container.viewControllers
        viewControllers.insert(module.toPresent(), at: index)
        self.container.viewControllers = viewControllers
        self.modules.insert(.push(module), at: index)
    }

    func lastModule() -> Presentable? {
        switch self.modules.last {
        case .modal(let module):
            return module
        case .push(let module):
            return module
        case .root(let module):
            return module
        default:
            return nil
        }
    }

    func enableInteractiveDismiss(_ enable: Bool) {
        if #available(iOS 13.0, *) {
            container.isModalInPresentation = enable == false
        }
    }
}
