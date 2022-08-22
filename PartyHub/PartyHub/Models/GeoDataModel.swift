//
//  GeoDataModel.swift
//  PartyHub
//
//  Created by Dinar Garaev on 22.08.2022.
//

import Foundation

struct GeoData: Codable {
    let response: Response

    struct Response: Codable {
        let geoObjectCollection: GeoObjectCollection

        enum CodingKeys: String, CodingKey {
            case geoObjectCollection = "GeoObjectCollection"
        }
    }

    struct GeoObjectCollection: Codable {
        let featureMember: [FeatureMember]
    }

    struct FeatureMember: Codable {
        let geoObject: GeoObject

        enum CodingKeys: String, CodingKey {
            case geoObject = "GeoObject"
        }
    }

    struct GeoObject: Codable {
        let point: Point

        enum CodingKeys: String, CodingKey {
            case point = "Point"
        }
    }

    struct Point: Codable {
        let pos: String
    }
}
