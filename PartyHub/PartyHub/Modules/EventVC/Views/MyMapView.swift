//
//  MyMapView.swift
//  PartyHub
//
//  Created by Dinar Garaev on 23.08.2022.
//

import UIKit
import YandexMapsMobile

final class MyMapView: YMKMapView {
    weak var rootVC: EventVC?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let res = super.hitTest(point, with: event) {
            print(#function, #line)
            rootVC?.scrollView.isScrollEnabled = false
            rootVC?.checkSum -= 1
            return res
        }
        return nil
    }
}
