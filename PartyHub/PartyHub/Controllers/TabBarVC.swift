//
//  File.swift
//  PartyHub
//
//  Created by juliemoorled on 14.08.2022.
//

import UIKit

final class TabBarVC: UITabBarController {

    // MARK: - Computed properties

    private lazy var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.1, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        styleTabBar()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let imageView = item.value(forKey: "view") as? UIView else { return }
        imageView.layer.add(bounceAnimation, forKey: nil)
    }

    // MARK: - Private methods

    private func styleTabBar() {
        view.backgroundColor = .systemGray6
        tabBar.tintColor = .label
    }

}
