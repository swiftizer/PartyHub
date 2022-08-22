//
//  UIView+DropShadow.swift
//  PartyHub
//
//  Created by Dinar Garaev on 16.08.2022.
//

import UIKit

extension UIView {
    func dropShadow(
        scale: Bool = true,
        shadowColor: UIColor = UIColor(hexString: "#000000").withAlphaComponent(0.12),
        shadowOpacity: Float = 0.12,
        shadowOffset: CGSize = CGSize(width: 0, height: 4),
        shadowRadius: CGFloat = 24
    ) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func addGradient(firstColor: UIColor, secondColor: UIColor) {
            let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height/2)
            gradientLayer.colors = [
                firstColor.cgColor,
                firstColor.cgColor,
                secondColor.cgColor
            ]
            self.layer.addSublayer(gradientLayer)
        }
}
