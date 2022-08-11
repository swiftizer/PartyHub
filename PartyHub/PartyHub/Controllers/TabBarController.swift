//
//  TabBarController.swift
//  PartyHub
//
//  Created by juliemoorled on 10.08.2022.
//

import UIKit

final class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBar()
        
    }
    
    func setUpTabBar() {
        viewControllers = [ generateTabBarItem(viewController: ViewController(), title: "Menu")]
    }
    
    func generateTabBarItem(viewController: UIViewController, title: String) -> UIViewController {
        viewController.tabBarItem.title = "title"
        return viewController
    }
    
}
