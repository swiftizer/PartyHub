//
//  CurLocationButton.swift
//  PartyHub
//
//  Created by Dinar Garaev on 20.08.2022.
//

import YandexMapsMobile
import UIKit

final class CurLocationButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -44, dy: -44).contains(point)
    }
}
