//
//  EventImageView.swift
//  PartyHub
//
//  Created by Dinar Garaev on 20.08.2022.
//

import UIKit

final class EventImageView: UIImageView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -150, dy: -50).contains(point)
    }
}
