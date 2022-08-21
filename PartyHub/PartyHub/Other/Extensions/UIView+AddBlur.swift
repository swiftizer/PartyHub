//
//  UIView+AddBlur.swift
//  PartyHub
//
//  Created by Dinar Garaev on 19.08.2022.
//

import UIKit

extension UIView {
    func addBlur(
        style: UIBlurEffect.Style,
        alpha: CGFloat,
        cornerRadius: CGFloat = 0,
        bounds: CGRect? = nil,
        cornerCurve: CALayerCornerCurve = .continuous,
        zPosition: CGFloat = 0
    ) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds ?? self.bounds
        blurEffectView.isUserInteractionEnabled = false
        blurEffectView.alpha = alpha
        blurEffectView.clipsToBounds = true
        blurEffectView.layer.cornerRadius = cornerRadius
        blurEffectView.layer.cornerCurve = cornerCurve
        blurEffectView.layer.zPosition = zPosition
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
    }
}
