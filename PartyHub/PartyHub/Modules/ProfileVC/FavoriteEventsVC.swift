//
//  ViewController.swift
//  PartyHub
//
//  Created by Сергей Николаев on 09.08.2022.
//

import UIKit
import CoreLocation

final class FavoriteEventsVC: UIViewController {

    var adapter: MenuTableViewAdapter

    // MARK: - Private properties

    private let menuTableView = UITableView()
    private let group: DispatchGroup = DispatchGroup()
    private var events = [Event]()
    private var distanses = [Double]()

    private var flagLocation = false
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?

    // MARK: - Initialization

    init() {
        self.adapter = MenuTableViewAdapter(tableView: menuTableView, needAddSection: false)
        super.init(nibName: nil, bundle: nil)
        adapter.relodeCells(events: [], location: nil, distances: [])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestAlwaysAuthorization()

        NotificationCenter.default.addObserver(self, selector: #selector(didPullToRefresh), name: NSNotification.Name("MenuTableViewCell.AdminDeleteEvent.Sirius.PartyHub"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didPullToRefresh), name: NSNotification.Name("TabBarCoordinator.UserIsLogged.Sirius.PartyHub"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didPullToRefresh), name: NSNotification.Name("ProfileCoordinator.PresentDescrption.Back.Sirius.PartyHub"), object: nil)

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            group.enter()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        view.addSubview(menuTableView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        menuTableView.pin
            .all()
            .marginTop(30)
    }

    // MARK: - Actions

    @objc
    private func didPullToRefresh() {
        loadData()
    }

    // MARK: - Methods

    func loadData() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        menuTableView.refreshControl = refreshControl
        menuTableView.refreshControl?.beginRefreshing()

        group.enter()
        EventManager.shared.downloadFollowedEvents { result in
            switch result {
            case .success(let events):
                self.events = events
                self.group.leave()

            case .failure(let error):
                let alertController = UIAlertController(title: nil, message: error.rawValue, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }

        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            self.menuTableView.refreshControl?.endRefreshing()
            self.events = self.sortEventsByDistance(events: self.events)
            self.getDistances()
            self.adapter.relodeCells(events: self.events, location: self.currentLocation!, distances: self.distanses)
        }
    }

    private func sortEventsByDistance(events: [Event]) -> [Event] {
        let sevents = events.sorted {
            let latitude1 = Double($0.place.split(separator: "|")[1]) ?? 0
            let longitude1 = Double($0.place.split(separator: "|")[2]) ?? 0
            let distance1 = (currentLocation?.distance(from: CLLocation(latitude: latitude1, longitude: longitude1)) ?? 0) / 1000.0

            let latitude2 = Double($1.place.split(separator: "|")[1]) ?? 0
            let longitude2 = Double($1.place.split(separator: "|")[2]) ?? 0
            let distance2 = (currentLocation?.distance(from: CLLocation(latitude: latitude2, longitude: longitude2)) ?? 0) / 1000.0

            return distance1 < distance2
        }

        return sevents
    }

    private func getDistances() {
        distanses = []
        for event in events {
            let latitude = Double(event.place.split(separator: "|")[1]) ?? 0
            let longitude = Double(event.place.split(separator: "|")[2]) ?? 0
            let distance = (currentLocation?.distance(from: CLLocation(latitude: latitude, longitude: longitude)) ?? 0) / 1000.0
            distanses.append(distance)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension FavoriteEventsVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        if !flagLocation {
            guard currentLocation != nil else {
                return
            }
            group.leave()
            flagLocation = true
        }
    }
}
