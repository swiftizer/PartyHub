//
//  CurLocationButton.swift
//  PartyHub
//
//  Created by Dinar Garaev on 21.08.2022.
//

import UIKit

final class CurLocationButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -4, dy: -4).contains(point)
    }
}
