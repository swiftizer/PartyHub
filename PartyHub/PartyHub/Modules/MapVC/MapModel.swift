//
//  MapModel.swift
//  PartyHub
//
//  Created by Сергей Николаев on 16.08.2022.
//

import Foundation
import YandexMapsMobile
import CoreLocation

struct MapModel {
    var dictionaryPoints: [YMKPlacemarkMapObject: GeoPoint] = [:]
    var points = [GeoPoint]()
    var currentLocation: CLLocation?
}
