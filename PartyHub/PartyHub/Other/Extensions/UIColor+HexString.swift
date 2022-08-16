//
//  UIColor+hexString.swift
//  PartyHub
//
//  Created by Dinar Garaev on 16.08.2022.
//

import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat? = nil) {
        var hex: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)

        var aValue: UInt64
        let rValue, gValue, bValue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (aValue, rValue, gValue, bValue) = (255, (rgbValue >> 4 & 0xF) * 17,
                                                (rgbValue >> 4 & 0xF) * 17, (rgbValue & 0xF) * 17)
        case 6: // RGB (24-bit)
            (aValue, rValue, gValue, bValue) = (255, rgbValue >> 16, rgbValue >> 8 & 0xFF, rgbValue & 0xFF)
        case 8: // ARGB (32-bit)
            (aValue, rValue, gValue, bValue) = (rgbValue >> 24, rgbValue >> 16 & 0xFF,
                                                rgbValue >> 8 & 0xFF, rgbValue & 0xFF)
        default: // gray as like systemGray
            (aValue, rValue, gValue, bValue) = (255, 123, 123, 129)
        }

        if let alpha = alpha, alpha >= 0, alpha <= 1 {
            aValue = UInt64(alpha * 255)
        }

        self.init(
            red: CGFloat(rValue) / 255,
            green: CGFloat(gValue) / 255,
            blue: CGFloat(bValue) / 255,
            alpha: CGFloat(aValue) / 255)
    }

    var hexString: String {
        let cgColorInRGB = cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!,
                                             intent: .defaultIntent,
                                             options: nil)!
        let colorRef = cgColorInRGB.components
        let red = colorRef?[0] ?? 0
        let green = colorRef?[1] ?? 0
        let blue = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : green) ?? 0
        let alpha = cgColor.alpha

        var color = String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(red * 255)),
            lroundf(Float(green * 255)),
            lroundf(Float(blue * 255))
        )

        if alpha < 1 {
            color += String(format: "%02lX", lroundf(Float(alpha * 255)))
        }

        return color
     }
}
