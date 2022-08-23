//
//  MyScrollView.swift
//  PartyHub
//
//  Created by Dinar Garaev on 23.08.2022.
//

import UIKit

final class MyScrollView: UIScrollView {
    weak var rootVC: EventVC?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let res = super.hitTest(point, with: event) {
            print(#function, #line)
            if rootVC?.checkSum ?? 1 == 1 {
                rootVC?.scrollView.isScrollEnabled = true
            } else {
                rootVC?.checkSum = 1
            }
            return res
        }
        return nil
    }
}
