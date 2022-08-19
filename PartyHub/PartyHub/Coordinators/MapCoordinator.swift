//
//  MapCoordinator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 11.08.2022.
//

import UIKit

final class MapCoordinator: Coordinator {
    var result: ((FlowResult<Void>) -> Void)?
    let router = DefaultRouter(with: nil)

    init() {
        (router.toPresent() as? UINavigationController)?.setNavigationBarHidden(false, animated: false)
        start()
    }

    func start() {
        let module = MapVC()
        module.title = "Map"
        let points = [
            GeoPoint(name: "event1", latitude: 43.41, longtitude: 39.946),
            GeoPoint(name: "event2", latitude: 43.41, longtitude: 39.959),
            GeoPoint(name: "event3", latitude: 43.423, longtitude: 39.956),
            GeoPoint(name: "event4", latitude: 43.40, longtitude: 39.954),
            GeoPoint(name: "event5", latitude: 43.39, longtitude: 39.976)
        ]
        module.loadPoints(points: points)

        router.setRootModule(module)
    }

    func toPresent() -> UIViewController {
        return router.toPresent()
    }

}
