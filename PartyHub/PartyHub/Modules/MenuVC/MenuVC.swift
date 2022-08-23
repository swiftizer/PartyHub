//
//  ViewController.swift
//  PartyHub
//
//  Created by Сергей Николаев on 09.08.2022.
//

import UIKit
import CoreLocation

final class MenuVC: UIViewController {

    var adapter: MenuTableViewAdapter

    // MARK: - Private properties

    private let menuTableView = UITableView()
    private let group: DispatchGroup = DispatchGroup()
    private var events = [Event]()
    private var distanses = [Double]()

    private var flagLocation = false
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var isFirst = true
    private let activityIndicator = LoadindIndicatorView()

    // MARK: - Initialization

    init() {
        self.adapter = MenuTableViewAdapter(tableView: menuTableView)
        super.init(nibName: nil, bundle: nil)
        adapter.relodeCells(events: [], location: nil, distances: [])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        menuTableView.pin
            .all()
    }

    // MARK: - Actions

    @objc
    private func didPullToRefresh() {
        loadData()
    }

    // MARK: - Methods

    func loadData() {
        if !isFirst {
            menuTableView.refreshControl?.beginRefreshing()
        }
        isFirst = false
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        menuTableView.refreshControl = refreshControl

        group.enter()
        EventManager.shared.downloadEvents { result in
            switch result {
            case .success(let events):
                self.events = events
                self.group.leave()
            case .failure(let error):
                let alertController = UIAlertController(title: nil, message: error.rawValue, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                FeedbackGenerator.shared.errorFeedbackGenerator()
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

    // MARK: - Private Methods

    private func setupUI() {
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                createDeniedAlertController()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            @unknown default:
                fatalError()
            }
            locationManager.delegate = self
            group.enter()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPullToRefresh),
                                               name: NSNotification.Name("AuthManager.SignOut.Sirius.PartyHub"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPullToRefresh),
                                               name: NSNotification.Name("TabBarCoordinator.UserIsLogged.Sirius.PartyHub"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPullToRefresh),
                                               name: NSNotification.Name("MenuTableViewCell.AdminDeleteEventSuccess.Sirius.PartyHub"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPullToRefresh),
                                               name: NSNotification.Name( "EventVC.BackAction.Sirius.PartyHub"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(activityIndicatorStart),
                                               name: NSNotification.Name("MenuTableViewCell.AdminDeleteEventStart.Sirius.PartyHub"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(activityIndicatorStopSuccess),
                                               name: NSNotification.Name("MenuTableViewCell.AdminDeleteEventSuccess.Sirius.PartyHub"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(activityIndicatorStopFailure),
                                               name: NSNotification.Name("MenuTableViewCell.AdminDeleteEventFailure.Sirius.PartyHub"),
                                               object: nil)

        loadData()

        view.addSubview(menuTableView)
        activityIndicator.pinToRootVC(rootVC: self)
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

    private func createDeniedAlertController() {
        let alert = UIAlertController(
            title: "Не удалось вас найти",
            message: "Пожалуйста, включите разрешение в настройках. Оно требуется для работы прилоения",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)
        let settingsAction = UIAlertAction(
            title: "Настройки",
            style: .default
        ) { [weak self] _ in
            self?.openSettings()
        }
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        present(alert, animated: true)
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}

private extension MenuVC {
    @objc
    func activityIndicatorStart() {
        activityIndicator.start()
    }

    @objc
    func activityIndicatorStopSuccess() {
        activityIndicator.stopSuccess()
    }

    @objc
    func activityIndicatorStopFailure() {
        activityIndicator.stopFailure()
    }
}

// MARK: - CLLocationManagerDelegate

extension MenuVC: CLLocationManagerDelegate {
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

