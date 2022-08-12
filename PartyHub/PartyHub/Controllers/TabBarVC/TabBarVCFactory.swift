//
//  TabBarVCFactory.swift
//  PartyHub
//
//  Created by juliemoorled on 12.08.2022.
//

import  UIKit

enum TabBarItem: String, CaseIterable {

    case list = "Menu"
    case map = "Map"
    case profile = "Profile"
    
    var itemImage: UIImage? {
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
        var viewConroller = UIViewController()
        switch tabBarItem {
        case  .list:
            viewConroller = ListVC()
        case .map:
            viewConroller = ListVC() //change VC
        case .profile:
            viewConroller = ListVC() //change VC
        }
        viewConroller.tabBarItem.title = tabBarItem.rawValue
        viewConroller.tabBarItem.image = tabBarItem.itemImage
        return viewConroller
    }
}
