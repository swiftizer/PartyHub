//
//  TabBarController.swift
//  PartyHub
//
//  Created by juliemoorled on 10.08.2022.
//

import UIKit
import PinLayout

enum TabBarItem: String, CaseIterable {

    case list = "Menu"
    case map = "Map"
    case profile = "Profile"

    var itemImages: UIImage? {
        switch self {
        case .list:
            return UIImage(systemName: "list.bullet")
        case .map:
            return UIImage(systemName: "map")
        case .profile:
            return UIImage(systemName: "person")
        }
    }
}

class TabBarVCFactory {
    func createTabBarVC(tabBarItem: TabBarItem) -> UIViewController {
        switch tabBarItem {
        case  .list:
            return ListVC()
        case .map:
            return ListVC() //change VC
        case .profile:
            return ListVC() //change VC
        }
    }
}

final class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTabBar()
        setUpTabBar()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let imageView = item.value(forKey: "view") as? UIView else { return }
        imageView.layer.add(bounceAnimation, forKey: nil)
    }
    
    private func styleTabBar() {
        tabBar.backgroundColor = .systemGray6
    }
    
    private func setUpTabBar() {
        let tabBarItems = [TabBarItem.list, TabBarItem.map, TabBarItem.profile]
        var viewControllers: [UIViewController] = []
        for item in tabBarItems {
            let tabBarVCFactory = TabBarVCFactory()
            let viewController = tabBarVCFactory.createTabBarVC(tabBarItem: item)
            viewController.tabBarItem.title = item.rawValue
            viewController.tabBarItem.image = item.itemImages
            viewControllers.append(viewController)
        }
        self.viewControllers = viewControllers
    }
    
    private lazy var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.1, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()
    
}
