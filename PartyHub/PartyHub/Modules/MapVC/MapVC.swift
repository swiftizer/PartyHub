//
//  MapVC.swift
//  PartyHub
//
//  Created by juliemoorled on 14.08.2022.
//

import UIKit
import PinLayout
import CoreLocation
import MapKit
import YandexMapsMobile

final class MapVC: UIViewController {

    enum Navigation {
        case description(event: Event)
    }

    var navigation: ((Navigation) -> Void)?

    // MARK: - Private Properties

    private var dictionaryPoints: [YMKPlacemarkMapObject: Event] = [:]
    private var currentLocation: CLLocation?
    private var userLocationLayer: YMKUserLocationLayer!
    private var flagLocation = false
    private var locationManager = CLLocationManager()
    private var tapGestureReconizer = UITapGestureRecognizer()
    private var events: [Event] = []

    private let mapView = YMKMapView()
    private let currentLocationButton = CurLocationButton()

    private let searchController: UISearchController = {
        let viewController = UISearchController(searchResultsController: nil)
        viewController.searchBar.placeholder = "Поиск"
        viewController.searchBar.tintColor = .label
        viewController.searchBar.searchBarStyle = .minimal
        viewController.definesPresentationContext = true
        return viewController
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupEvents()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    // MARK: - Methods

    func getUserLocation() {
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        let mapKit = YMKMapKit.sharedInstance()
        userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true

        mapView.mapWindow.map.mapObjects.addTapListener(with: self)
        userLocationLayer.setObjectListenerWith(self)

        currentLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
        currentLocationButton.backgroundColor = .systemGray6
        currentLocationButton.tintColor = .label
        currentLocationButton.layer.cornerRadius = 20
        currentLocationButton.addTarget(self, action: #selector(clickedCurrentLocationButton), for: .touchUpInside)
    }

    // MARK: - Private Metods

    private func setupEvents() {
        EventManager.shared.downloadEvents { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let events):
                    self?.events = events
                    self?.setEvents()
                case .failure(let error):
                    debugPrint(error.rawValue)
                }
            }
        }
    }

    private func setup() {
        view.backgroundColor = .systemGray6
        view.addSubview(mapView)
        mapView.addSubview(currentLocationButton)

        tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))

        navigationItem.title = "Map"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController

        getUserLocation()
    }

    private func setEvents() {
        for event in events {
            let latitude = Double(event.place.split(separator: "|")[1]) ?? 0
            let longitude = Double(event.place.split(separator: "|")[2]) ?? 0
            let mapObjects = mapView.mapWindow.map.mapObjects
            let placemark = mapObjects.addPlacemark(with: YMKPoint(latitude: latitude, longitude: longitude))
            let image = UIImage(named: "eventTag")?.resizeImage(
                targetSize: CGSize(
                    width: 250 * UIScreen.main.bounds.height/926,
                    height: 250 * UIScreen.main.bounds.height/926
                )
            )
            placemark.setIconWith(
                image?.withTintColor(UIColor(
                    red: 0.205,
                    green: 0.369,
                    blue: 0.792,
                    alpha: 1
                ), renderingMode: .alwaysOriginal) ?? UIImage()
            )
            dictionaryPoints.updateValue(event, forKey: placemark)
        }
    }

    private func setupLayout() {
        mapView.pin
            .bottom(view.pin.safeArea)
            .left()
            .right()
            .top()

        currentLocationButton.pin
            .bottomRight(to: mapView.anchor.bottomRight)
            .height(40)
            .width(40)
            .marginRight(15)
            .marginBottom(30)
    }
}

// MARK: - Actions

private extension MapVC {
    @objc
    func clickedCurrentLocationButton() {
        guard let location = currentLocation else {
            return
        }

        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: YMKPoint(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                ),
                zoom: 15,
                azimuth: 0,
                tilt: 0
            ),
            animationType: YMKAnimation(
                type: YMKAnimationType.smooth,
                duration: 0.3
            ),
            cameraCallback: nil
        )
    }

    @objc
    func closeKeyboard() {
        if !searchController.isActive { return }
        print(#function)

        view.endEditing(true)
        navigationController?.view.endEditing(true)
    }
}

// MARK: - UISearchResultsUpdating, UISearchBarDelegate

extension MapVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        return
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty
        else { return }

        print(query)
        let JSONAdress = query.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)

        NetworkManager.shared.getCoordinates(with: JSONAdress) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let res):
                    guard let longtitude = res.longtitude,
                          let latitude = res.latitude
                    else { return }

                    self?.mapView.mapWindow.map.move(
                        with: YMKCameraPosition(
                            target: YMKPoint(
                                latitude: longtitude,
                                longitude: latitude
                            ),
                            zoom: 15,
                            azimuth: 0,
                            tilt: 0
                        ),
                        animationType: YMKAnimation(
                            type: YMKAnimationType.smooth,
                            duration: 1
                        ),
                        cameraCallback: nil
                    )
                case .failure(let error):
                    let alertController = UIAlertController(title: nil, message: error.rawValue, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel)
                    alertController.addAction(okAction)
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - UISearchControllerDelegate

extension MapVC: UISearchControllerDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapGestureReconizer)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapGestureReconizer)
    }
}

// MARK: - YMKMapObjectTapListener

extension MapVC: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        if let placemark = mapObject as? YMKPlacemarkMapObject {
            if let event = dictionaryPoints[placemark] {
                navigation?(.description(event: event))
            }
        }
        return true
    }
}

// MARK: - YMKUserLocationObjectListener

extension MapVC: YMKUserLocationObjectListener {
    func onObjectAdded(with view: YMKUserLocationView) {
        let pinPlacemark = view.pin.useCompositeIcon()
        pinPlacemark.setIconWithName(
            "SearchResult",
            image: UIImage(named: "SearchResult") ?? UIImage(),
            style: YMKIconStyle(
                anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                rotationType: YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 1,
                flat: true,
                visible: true,
                scale: 1,
                tappableArea: nil
            )
        )

        view.accuracyCircle.fillColor = UIColor.lightGray
    }

    func onObjectRemoved(with view: YMKUserLocationView) {}

    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
}

// MARK: - CLLocationManagerDelegate

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        if !flagLocation {
            guard currentLocation != nil else {
                return
            }
            flagLocation = true

            clickedCurrentLocationButton()
        }
    }
}
