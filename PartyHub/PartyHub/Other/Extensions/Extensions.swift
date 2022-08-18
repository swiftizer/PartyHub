//
//  Extensions.swift
//  PartyHub
//
//  Created by juliemoorled on 15.08.2022.
//

import UIKit

extension UIView {

    func dropShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 2.4
        // TODO: - Будет версия Динара
    }

    func addGradient(firstColor: UIColor, secondColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            firstColor.cgColor,
            secondColor.cgColor,
            secondColor.cgColor
        ]
        self.layer.addSublayer(gradientLayer)
    }

}
