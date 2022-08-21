//
//  UIView+InvalidAnimation.swift
//  PartyHub
//
//  Created by Dinar Garaev on 18.08.2022.
//

import UIKit

extension UIView {
    func invalidAnimation(for view: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 2
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
        view.layer.add(animation, forKey: "position")
    }

    func repaintBorder(for views: [UIView], borderWidth: CGFloat, color: UIColor) {
        views.forEach({
            $0.layer.borderWidth = borderWidth
            $0.layer.borderColor = color.cgColor
        })
    }
}
