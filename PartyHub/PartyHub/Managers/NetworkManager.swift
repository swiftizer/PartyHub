//
//  NetworkManager.swift
//  PartyHub
//
//  Created by Сергей Николаев on 16.08.2022.
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

struct GeoPoint {
    let name: String?
    let latitude: Double?
    let longtitude: Double?
}

enum NetworkError: String, Error {
    case findError
    case invalidUrl
    case emptyData
    case badAttempt
}

final class NetworkManager {
    static let shared = NetworkManager()

    private let token = "086122f3-e4e2-467e-915b-5e6d09e5ff35"

    private init() {}

    // MARK: JSON в виде текста
    func getCoordinates(
        with adress: String,
        curLocation: GeoPoint,
        completion: @escaping (Result<GeoPoint, NetworkError>) -> Void
    ) {
        let urlString = "https://geocode-maps.yandex.ru/1.x/?apikey=\(token)&format=json&geocode=\(adress)&lang=en_RU".encodeUrl

        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(NetworkError.invalidUrl))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.emptyData))
                return
            }

            do {
                let geoData = try JSONDecoder().decode(GeoData.self, from: data)

                guard let coordsStr = geoData.response.geoObjectCollection.featureMember.first?.geoObject.point.pos
                else {
                    completion(.failure(NetworkError.findError))
                    return
                }

                let latitude = Double((coordsStr.split(separator: " ")[0]))
                let longtitude = Double((coordsStr.split(separator: " ")[1]))
                let res = GeoPoint(name: adress, latitude: latitude, longtitude: longtitude)
                completion(.success(res))

            } catch let error {
                debugPrint(error)
                completion(.failure(NetworkError.emptyData))
            }
        }.resume()
    }
}
