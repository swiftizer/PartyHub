//
//  UIView+InvalidAnimation.swift
//  PartyHub
//
//  Created by Dinar Garaev on 18.08.2022.
//

import UIKit

extension UIView {
    func invalidAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 2
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 10, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 10, y: center.y))
        layer.add(animation, forKey: "position")
    }

    func repaintBorder(borderWidth: CGFloat = 1, color: UIColor = .red.withAlphaComponent(0.6)) {
        layer.borderWidth = borderWidth
        layer.borderColor = color.cgColor
    }
}
