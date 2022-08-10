//
//  Coordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 10.08.2022.
//

import UIKit

/// Протокол координатора
protocol Coordinator {
    var tabBarVC: UITabBarController { get set }
    func start()
}
