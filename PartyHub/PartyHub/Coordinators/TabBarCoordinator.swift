//
//  TabBarCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 10.08.2022.
//

import UIKit

final class TabBarCoordinator: NSObject, Coordinator {
    typealias Result = Void

    var result: ((FlowResult<Void>) -> Void)?

    private let router: TabBarRouter

    init(with items: [TabBarControllerItem]) {
        self.router = .init(with: items.map { $0.module })
        super.init()
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
