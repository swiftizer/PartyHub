//
//  File.swift
//  PartyHub
//
//  Created by juliemoorled on 14.08.2022.
//

import UIKit

final class TabBarVC: UITabBarController {

    // MARK: - Computed Properties

    private lazy var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.1, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        return bounceAnimation
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TabBarVC {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let imageView = item.value(forKey: "view") as? UIView else { return }
        imageView.layer.add(bounceAnimation, forKey: nil)
    }
}
