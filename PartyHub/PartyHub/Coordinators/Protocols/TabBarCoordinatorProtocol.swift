//
//  TabBarCoordinatorProtocol.swift
//  PartyHub
//
//  Created by Dinar Garaev on 10.08.2022.
//

import UIKit

/// Протокол TabBar координатора
protocol TabBarCoordinatorProtocol: AnyObject {
    var tabBarVC: UITabBarController { get set }
    func start()
}
