//
//  TabBarController.swift
//  PartyHub
//
//  Created by juliemoorled on 10.08.2022.
//

import UIKit
import PinLayout

final class TabBarVC: UITabBarController {
    
    enum TabBarItem: String, CaseIterable {
        
        case list = "Menu"
        case map = "Map"
        case profile = "Profile"
        
        var viewController: UIViewController {
            switch self {
            case .list:
                return ListVC()
            case .map:
                return ListVC() //change VC
            case .profile:
                return ListVC() //change VC
            }
        }
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        styleTabBar()
    }
    
    private func setUpTabBar() {
        
        viewControllers = [generateTabBarItem(tabBarItem: .list),
                           generateTabBarItem(tabBarItem: .map),
                           generateTabBarItem(tabBarItem: .profile)]
    }
    
    private func generateTabBarItem(tabBarItem: TabBarItem) -> UIViewController {
        let viewController = tabBarItem.viewController
        viewController.tabBarItem.title = tabBarItem.rawValue
        viewController.tabBarItem.image = tabBarItem.itemImages
        return viewController
    }
    
    private func styleTabBar() {
        tabBar.backgroundColor = .systemGray6
    }
    
}
