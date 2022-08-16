//
//  MapVC.swift
//  PartyHub
//
//  Created by juliemoorled on 14.08.2022.
//

import UIKit
import Foundation
import PinLayout
import CoreLocation
import MapKit
import YandexMapsMobile

final class CurLocationButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -44, dy: -44).contains(point)
    }
}

final class ChooseButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -30, dy: -55).contains(point)
    }
}

final class MapVC: UIViewController {

    // MARK: - Private Properties

    private var model = MapModel()
    private var userLocationLayer: YMKUserLocationLayer!
    private let mapView = YMKMapView()
    private let currentLocationButton = CurLocationButton()
    private var flagLocation = false
    private var locationManager = CLLocationManager()
    private var tapGestureReconizer = UITapGestureRecognizer()
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        mapView.pin
            .bottom(view.pin.safeArea)
            .left()
            .right()
            .top()
        view.backgroundColor = .systemGray6

        currentLocationButton.pin
            .bottomRight(to: mapView.anchor.bottomRight)
            .height(35)
            .width(35)
            .marginRight(15)
            .marginBottom(30)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
    }


    // MARK: - Private Metods

    private func setup() {

        view.addSubview(mapView)
        mapView.addSubview(currentLocationButton)

        tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))

        navigationItem.title = "Map"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        getUserLocation()
        setPoints(points: model.points)
    }

    private func setPoints(points: [GeoPoint]) {
        for point in points {
            if let latitude = point.latitude, let longtitude = point.longtitude {
                let mapObjects = mapView.mapWindow.map.mapObjects
                let placemark = mapObjects.addPlacemark(with: YMKPoint(latitude: latitude, longitude: longtitude))
                let image = UIImage(named: "eventTag")?.resizeImage(targetSize: CGSize(width: 200, height: 200))
                placemark.setIconWith(
                    image?.withTintColor(UIColor(
                        red: 0.205,
                        green: 0.369,
                        blue: 0.792,
                        alpha: 1), renderingMode: .alwaysOriginal) ?? UIImage())
                model.dictionaryPoints.updateValue(point, forKey: placemark)
            }
        }
    }

    // MARK: - Public Methods

    func loadPoints(points: [GeoPoint]) {
        self.model.points = points
    }

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
        currentLocationButton.layer.cornerRadius = 18
        currentLocationButton.addTarget(self, action: #selector(clickedCurrentLocationButton), for: .touchUpInside)
    }
}

// MARK: - Actions

private extension MapVC {
    @objc
    func clickedCurrentLocationButton() {
        guard let location = model.currentLocation else {
            return
        }

        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target:
                                        YMKPoint(latitude: location.coordinate.latitude,
                                                 longitude: location.coordinate.longitude),
                                    zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.3),
            cameraCallback: nil)
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

        NetworkManager.shared.getCoordinates(
            with: JSONAdress,
            curLocation: GeoPoint(
                name: "curLoc",
                latitude: model.currentLocation?.coordinate.latitude,
                longtitude: model.currentLocation?.coordinate.longitude
            )
        ) { result in
                    DispatchQueue.main.async {
                switch result {

                case .success(let res):
                    print(query, res.longtitude!, res.latitude!)
                    self.mapView.mapWindow.map.move(
                        with: YMKCameraPosition(target:
                                                    YMKPoint(latitude: res.longtitude!,
                                                             longitude: res.latitude!),
                                                zoom: 15, azimuth: 0, tilt: 0),
                        animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
                        cameraCallback: nil)

                case .failure(let error):
                    let alertController = UIAlertController(title: nil, message: error.rawValue, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    print("ГГ")
                    print("Error! \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - UISearchControllerDelegate

extension MapVC: UISearchControllerDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print(#function)
        view.addGestureRecognizer(tapGestureReconizer)

//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.mapView.pin.all(self.view.pin.safeArea)
//        }
//        DispatchQueue.global().async {
//            usleep(1)
//            DispatchQueue.main.async { [weak self] in
//                self?.mapView.pin.all((self?.view.pin.safeArea)!)
//            }
//        }
//        mapView.pin.all(view.pin.safeArea)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapGestureReconizer)


//        DispatchQueue.global().async {
//            usleep(1)
//            DispatchQueue.main.async { [weak self] in
//                self?.mapView.pin.all((self?.view.pin.safeArea)!)
//            }
//        }
    }

    func didPresentSearchController(_ searchController: UISearchController) {
        print(#function)
    }
}

// MARK: - YMKMapObjectTapListener

extension MapVC: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        print("tap:")
        if let placemark = mapObject as? YMKPlacemarkMapObject {
            if let point = model.dictionaryPoints[placemark] {
                print(point.name, point.latitude!, point.longtitude!)

                let viewController = EventViewController(point: point)
        //        let viewController = UIViewController()
                viewController.title = point.name
//                viewController.view.backgroundColor = .systemBackground
                let navigationController = UINavigationController(rootViewController: viewController)
                present(navigationController, animated: true, completion: nil)
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
                tappableArea: nil))

        view.accuracyCircle.fillColor = UIColor.lightGray
    }

    func onObjectRemoved(with view: YMKUserLocationView) {}

    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
}

// MARK: - EventViewController

final class EventViewController: UIViewController {
    private let coordLabel = UILabel()
    private let point: GeoPoint

    init(point: GeoPoint) {
        self.point = point
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        title = point.name
        coordLabel.text = "\(point.latitude!), \(point.longtitude!)"
        coordLabel.font = .systemFont(ofSize: 25, weight: .bold)
        coordLabel.numberOfLines = 0
        view.backgroundColor = .systemBackground
        view.addSubview(coordLabel)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        coordLabel.pin
            .center()
            .maxWidth(UIScreen.main.bounds.width)
            .sizeToFit()
    }
}

// MARK: - CLLocationManagerDelegate

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        model.currentLocation = locations.last!
        if !flagLocation {
            guard model.currentLocation != nil else {
                return
            }
            flagLocation = true

            clickedCurrentLocationButton()
        }
    }
}
