//
//  CLLocation.swift
//  PartyHub
//
//  Created by Dinar Garaev on 19.08.2022.
//

import CoreLocation

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1)}
    }

    func fetchName(completion: @escaping (_ name: String?, _ error: Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.name, $1)}
    }
}
