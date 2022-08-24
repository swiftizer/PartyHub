//
//  EventVC.swift
//  PartyHub
//
//  Created by juliemoorled on 18.08.2022.
//

import UIKit
import PinLayout
import CoreLocation
import YandexMapsMobile

final class EventVC: UIViewController {
    enum Navigation {
        case back
        case go
    }

    var navigation: ((Navigation) -> Void)?
    var currentLocation: CLLocation?
    var checkSum = 1

    let scrollView: MyScrollView = {
        let scrollView = MyScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    // MARK: - Private properties

    private struct Constants {
        static let labelWidthMultiplier: CGFloat = 0.85
        static let labelHeight: CGFloat = 24
        static let buttonHeight: CGFloat = 50
    }

    private var event: Event
    private let eventImageView = UIImageView()
    private let dateLabel = UILabel()
    private let addressLabel = UILabel()
    private let priceLabel = UILabel()
    private let contactsLabel = UILabel()
    private let participantsLabel = UILabel()
    private var flagStartDragMap = false

    private var userLocationLayer: YMKUserLocationLayer!
    private var flagLocation = false
    private var locationManager = CLLocationManager()
    private let mapView = MyMapView()
    private let currentLocationButton = CurLocationButton()
    private let currentTagButton = UIButton()

    private let eventNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var goForEventButton: UIButton = {
        let button = UIButton(type: .system)
        EventManager.shared.isEventFollowedByUser(event: event) { [weak self] res in // TODO : - вынести отсюда
            switch res {
            case .success(let variant):
                if variant {
                    button.repaintButton(to: .cancel)
                } else {
                    button.repaintButton(to: .go)
                }

            case .failure:
                button.repaintButton(to: .go)
            }
        }
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapGoButton), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()

    private let dateImageName = "clock"
    private let addressImageName = "mappin.and.ellipse"
    private let priceImageName = "dollarsign.circle"
    private let participantsImageName = "person.2"
    private let contactsImageName = "link"
    private let xmarkImageName = "xmark.circle"

    // MARK: - Initialization

    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        setupUI()
        setupNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpLayout()
        setupBackground()
    }

    // MARK: - Actions

    @objc
    private func didTapGoButton() {
        checkTitleButton()
        navigation?(.go)
    }

    @objc
    private func backAction() {
        NotificationCenter.default.post(name: NSNotification.Name( "EventVC.BackAction.Sirius.PartyHub"), object: nil)
        FeedbackGenerator.shared.customFeedbackGeneration(.medium)
        navigation?(.back)
    }

    @objc
    private func contactsLabelClicked() {
        guard let url = URL(string: event.contacts.trimmingCharacters(in: .whitespacesAndNewlines)) else { return }
        let application = UIApplication.shared
        application.open(url)
    }

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
    func clickedCurrentTagButton() {
        let latitude = Double(event.place.split(separator: "|")[1]) ?? 0
        let longitude = Double(event.place.split(separator: "|")[2]) ?? 0

        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: YMKPoint(
                    latitude: latitude,
                    longitude: longitude
                ),
                zoom: 15,
                azimuth: 0,
                tilt: 0
            ),
            animationType: YMKAnimation(
                type: YMKAnimationType.smooth,
                duration: 0.4
            ),
            cameraCallback: nil
        )
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

        currentLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
        currentLocationButton.backgroundColor = .systemGray6
        currentLocationButton.tintColor = .label
        currentLocationButton.layer.cornerRadius = 20
        currentLocationButton.addTarget(self, action: #selector(clickedCurrentLocationButton), for: .touchUpInside)

        currentTagButton.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        currentTagButton.backgroundColor = .systemGray6
        currentTagButton.tintColor = .label
        currentTagButton.layer.cornerRadius = 20
        currentTagButton.addTarget(self, action: #selector(clickedCurrentTagButton), for: .touchUpInside)
    }

    // MARK: - Private methods

    private func checkTitleButton() {
        let group = DispatchGroup()
        goForEventButton.isUserInteractionEnabled = false

        group.enter()
        if self.goForEventButton.titleLabel?.text == "Иду!" {
            EventManager.shared.goToEvent(event: event) { [weak self] res in
                switch res {
                case.success:
                    self?.goForEventButton.repaintButton(to: .cancel)
                    group.leave()
                case .failure:
                    FeedbackGenerator.shared.errorFeedbackGenerator()
                    self?.goForEventButton.isUserInteractionEnabled = true
                }
            }

            group.enter()
            EventManager.shared.updateParticipantsCount(for: event, to: event.countOfParticipants + 1) { [weak self] res in
                switch res {
                case.success:
                    self?.event.countOfParticipants += 1
                    group.leave()
                case .failure:
                    FeedbackGenerator.shared.errorFeedbackGenerator()
                    self?.goForEventButton.isUserInteractionEnabled = true
                }
            }
        } else {
            EventManager.shared.cancelGoToEvent(event: event) { [weak self] res in
                switch res {
                case.success:
                    self?.goForEventButton.repaintButton(to: .go)
                    group.leave()
                case .failure:
                    FeedbackGenerator.shared.errorFeedbackGenerator()
                    self?.goForEventButton.isUserInteractionEnabled = true
                }
            }

            group.enter()
            EventManager.shared.updateParticipantsCount(for: event, to: event.countOfParticipants - 1) { [weak self] res in
                switch res {
                case.success:
                    self?.event.countOfParticipants -= 1
                    group.leave()
                case .failure:
                    FeedbackGenerator.shared.errorFeedbackGenerator()
                    self?.goForEventButton.isUserInteractionEnabled = true
                }
            }
        }

        group.notify(queue: DispatchQueue.main) {
            self.setupIconWithLabel(
                label: self.participantsLabel,
                iconName: self.participantsImageName,
                text: "\(self.event.countOfParticipants)"
            )
            FeedbackGenerator.shared.succesFeedbackGenerator()
            self.goForEventButton.isUserInteractionEnabled = true
        }
    }

    private func setupUI() {
        let eventPlace = String(describing: event.place.split(separator: "|")[0])
        eventNameLabel.text = event.title
        eventNameLabel.numberOfLines = 0
        descriptionLabel.text = event.description
        setupIconWithLabel(label: dateLabel,
                           iconName: dateImageName,
                           text: "\(event.begin) - \(event.end)")
        setupIconWithLabel(label: addressLabel,
                           iconName: addressImageName,
                           text: eventPlace)
        setupIconWithLabel(label: priceLabel,
                           iconName: priceImageName,
                           text: (event.cost == 0) ? "FREE" : "\(event.cost) ₽")
        setupIconWithLabel(label: contactsLabel,
                           iconName: contactsImageName,
                           text: (event.contacts == "") ? "-" : "\(event.contacts)")
        setupIconWithLabel(label: participantsLabel,
                           iconName: participantsImageName,
                           text: "\(event.countOfParticipants)")

        contactsLabel.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(contactsLabelClicked))
        contactsLabel.addGestureRecognizer(guestureRecognizer)
        scrollView.rootVC = self

        setupMapView()
    }

    private func setupBackground() {
        view.backgroundColor = .systemBackground
        view.addSubview(eventImageView)
        setupImage()
        view.addGradient(
            firstColor: .systemBackground.withAlphaComponent(0),
            secondColor: .systemBackground
        )
        view.addSubview(scrollView)
        scrollView.addSubview(goForEventButton)
        scrollView.addSubview(eventNameLabel)
        scrollView.addSubview(descriptionLabel)
    }

    private func setupImage() {
        ImageManager.shared.downloadImage(with: event.imageName) { [weak self] result in
            switch result {
            case .success(let imageRes):
                self?.eventImageView.image = imageRes.image
            case .failure(let error):
                debugPrint(error.rawValue)
            }
        }
    }

    private func setupNavigationBar() {
        let backNavigationItem = UIBarButtonItem(
            image: UIImage(systemName: xmarkImageName),
            style: .plain,
            target: self,
            action: #selector(backAction)
        )

        navigationItem.rightBarButtonItem = backNavigationItem
    }

    private func setupMapView() {
        scrollView.addSubview(mapView)
        mapView.addSubview(currentLocationButton)
        mapView.addSubview(currentTagButton)
        getUserLocation()

        mapView.layer.masksToBounds = true
        mapView.layer.cornerRadius = 15
        mapView.rootVC = self
        userLocationLayer.setObjectListenerWith(self)

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

        clickedCurrentTagButton()
    }

    private func setupIconWithLabel(label: UILabel, iconName: String, text: String) {
        if let icon = UIImage(systemName: iconName) {
            let labelText = NSMutableAttributedString()
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = icon.withTintColor(.label)
            let textAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),
                                 NSAttributedString.Key.foregroundColor: UIColor.label]
            let textAttachment = NSMutableAttributedString(
                string: text,
                attributes: textAttribute as [NSAttributedString.Key: Any]
            )
            labelText.append(NSAttributedString(attachment: imageAttachment))
            labelText.append(NSAttributedString(string: " "))
            labelText.append(textAttachment)
            label.attributedText = labelText
            label.textAlignment = .left
            scrollView.addSubview(label)
        }
    }

    private func setUpLayout() {
        eventImageView.pin
            .top()
            .left()
            .right()
            .height(view.frame.height/2)

        scrollView.pin
            .top(view.safeAreaInsets.top)
            .left()
            .right()
            .bottom()

        eventNameLabel.pin
            .top(eventImageView.frame.height - 72)
            .hCenter()
            .maxWidth(view.frame.width * Constants.labelWidthMultiplier)
            .sizeToFit(.width)

        let labelsWithImages = [dateLabel, addressLabel, priceLabel, contactsLabel, participantsLabel]
        var labelTop = eventNameLabel.frame.maxY + 12
        for label in labelsWithImages {
            label.pin
                .top(labelTop)
                .hCenter()
                .width(view.frame.width * Constants.labelWidthMultiplier)
                .height(Constants.labelHeight)
            labelTop += Constants.labelHeight
            labelTop += 8
        }

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: participantsLabel.bottomAnchor, constant: 12),
            descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: participantsLabel.widthAnchor)
        ])

        mapView.pin
            .below(of: descriptionLabel)
            .marginTop(12)
            .hCenter()
            .width(view.frame.width * Constants.labelWidthMultiplier)
            .height(240)

        currentLocationButton.pin
            .bottomRight(to: mapView.anchor.bottomRight)
            .height(40)
            .width(40)
            .marginRight(15)
            .marginBottom(15)

        currentTagButton.pin
            .bottomLeft(to: mapView.anchor.bottomLeft)
            .height(40)
            .width(40)
            .marginLeft(15)
            .marginBottom(15)

        goForEventButton.pin
            .top(mapView.frame.maxY + 24)
            .hCenter()
            .width(view.frame.width * Constants.labelWidthMultiplier)
            .height(Constants.buttonHeight)

        let scrollViewContentSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height + descriptionLabel.height + eventNameLabel.height + mapView.height - 100
        )

        scrollView.contentSize = scrollViewContentSize
    }
}

// MARK: - YMKUserLocationObjectListener

extension EventVC: YMKUserLocationObjectListener {
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

        view.accuracyCircle.fillColor = UIColor.systemIndigo.withAlphaComponent(0.6)
    }

    func onObjectRemoved(with view: YMKUserLocationView) {}

    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
}

extension EventVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        if !flagLocation {
            guard currentLocation != nil else {
                return
            }
            flagLocation = true
        }
    }
}

// TODO: - вынести отсюда

enum GoButtonState {
    case go
    case cancel
}

extension UIButton {
    func repaintButton(to state: GoButtonState) {
        switch state {
        case .go:
            backgroundColor = .systemIndigo.withAlphaComponent(0.8)
            setTitle("Иду!", for: .normal)
        case .cancel:
            backgroundColor = .red.withAlphaComponent(0.6)
            setTitle("Отказаться", for: .normal)
        }
    }
}
