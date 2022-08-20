//
//  EventVC.swift
//  PartyHub
//
//  Created by juliemoorled on 18.08.2022.
//

import UIKit
import PinLayout

final class EventVC: UIViewController {

    enum Navigation {
        case map
        case back
    }

    var navigation: ((Navigation) -> Void)?

    // MARK: - Internal properties

    var eventName: String = "Event Name"
    var eventDate: String = "Some date and time"
    var eventAddress: String = "Somewhere on Earth"
    var eventDescription: String = "Some description"
    var eventPrice: Int = 0
    var participants: Int = 0
    var eventImage = UIImage()
    var isFavorite: Bool = false

    // MARK: - Private properties

    private let eventImageView = UIImageView()
    private let scrollView = UIScrollView()
    private let eventNameLabel = UILabel()
    private let dateLabel = UILabel()
    private let addressLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let participantsLabel = UILabel()
    private let mapButton = UIButton(type: .system)

    private let dateImageName = "clock"
    private let addressImageName = "mappin.and.ellipse"
    private let priceImageName = "dollarsign.circle"
    private let participantsImageName = "person.2"
    private let favoriteImageName = "heart.fill"
    private let notFavoriteImageName = "heart"

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBackground()
        setUpEventNameLabel()
        setUpIconWithLabel(label: dateLabel,
                           iconName: dateImageName,
                           text: eventDate)
        setUpIconWithLabel(label: addressLabel,
                           iconName: addressImageName,
                           text: eventAddress)
        setUpIconWithLabel(label: priceLabel,
                           iconName: priceImageName,
                           text: (eventPrice == 0) ? "FREE" : "\(eventPrice)")
        setUpIconWithLabel(label: participantsLabel,
                           iconName: participantsImageName,
                           text: "\(participants)")

        setUpDescriptionLabel()
        setUpMapButton()
        setUpNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpLayout()
        setUpBackground()
    }

    // MARK: - Actions

    @objc
    private func didTapMapButton() {
        navigation?(.map)
    }

    @objc
    private func didTapFavoriteButton() {
        if isFavorite {
            isFavorite = false
        } else {
            isFavorite = true
        }
        setUpFavoriteButton()
        // make event favorite
    }

    @objc
    private func backAction() {
        dismiss(animated: true)
//        navigation?(.back)
    }

    // MARK: - Private Methods

    private func setUpBackground() {
        view.addSubview(eventImageView)
        eventImageView.backgroundColor = .systemIndigo
        view.addGradient(firstColor: .systemBackground.withAlphaComponent(0.1),
                         secondColor: .systemBackground)
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
    }

    private func setUpNavigationBar() {
        if #available(iOS 15, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = .clear
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationController?.navigationBar.backgroundColor = .clear
        }
        navigationController?.navigationBar.tintColor = .label
        tabBarController?.tabBar.isHidden = true


        let backNavigationItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle"),
            style: .plain,
            target: self,
            action: #selector(backAction)
        )

        backNavigationItem.tintColor = .label
        navigationItem.leftBarButtonItem = backNavigationItem

        setUpFavoriteButton()
    }

    private func setUpFavoriteButton() {
        let favoriteButton = UIBarButtonItem(
            image: UIImage(
                systemName: isFavorite ? favoriteImageName : notFavoriteImageName
            ),
            style: .plain,
            target: self,
            action: #selector(didTapFavoriteButton))
        navigationItem.rightBarButtonItem = favoriteButton
    }

    private func setUpEventNameLabel() {
        scrollView.addSubview(eventNameLabel)
        eventNameLabel.text = eventName
        eventNameLabel.font = .systemFont(ofSize: 28, weight: .semibold)
        eventNameLabel.textColor = .label
        eventNameLabel.textAlignment = .left
    }

    private func setUpIconWithLabel(label: UILabel, iconName: String, text: String) {
        if let icon = UIImage(systemName: iconName) {
            let labelText = NSMutableAttributedString()
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = icon.withTintColor(.label)
            let textAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),
                                 NSAttributedString.Key.foregroundColor: UIColor.label ]
            let textAttachment = NSMutableAttributedString(string: text,
                                                           attributes: textAttribute as [ NSAttributedString.Key: Any ])
            labelText.append(NSAttributedString(attachment: imageAttachment))
            labelText.append(NSAttributedString(string: " "))
            labelText.append(textAttachment)
            label.attributedText = labelText
            label.textAlignment = .left
            scrollView.addSubview(label)
        }
    }

    private func setUpDescriptionLabel() {
        scrollView.addSubview(descriptionLabel)
        descriptionLabel.text = eventDescription
        descriptionLabel.font = .systemFont(ofSize: 17, weight: .regular)
        descriptionLabel.textColor = .label
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
    }

    private func setUpMapButton() {
        scrollView.addSubview(mapButton)
        mapButton.backgroundColor = .systemIndigo.withAlphaComponent(0.8)
        mapButton.setTitle("Show on map", for: .normal)
        mapButton.layer.cornerRadius = 15
        mapButton.addTarget(self, action: #selector(didTapMapButton), for: .touchUpInside)
        mapButton.setTitleColor(.white, for: .normal)
        mapButton.setTitleColor(.systemGray6, for: .highlighted)
    }

    private func setUpLayout() {

        let labelWidth: CGFloat = view.frame.width * 0.85
        let labelHeight: CGFloat = 24

        eventImageView.pin
            .top()
            .left()
            .right()
            .height(view.frame.height/2)

        scrollView.pin
            .all()

        eventNameLabel.pin
            .top(eventImageView.frame.height - 72)
            .hCenter()
            .width(labelWidth)
            .height(labelHeight)

        let labelsWithImages = [dateLabel, addressLabel, priceLabel, participantsLabel]
        var labelTop = eventNameLabel.frame.maxY + 12
        for label in labelsWithImages {
            label.pin
                .top(labelTop)
                .hCenter()
                .width(labelWidth)
                .height(labelHeight)
            labelTop += labelHeight
            labelTop += 8
        }

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: participantsLabel.bottomAnchor, constant: 12),
            descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: participantsLabel.widthAnchor)
        ])

        mapButton.pin
            .top(descriptionLabel.frame.maxY + 12)
            .hCenter()
            .width(labelWidth)
            .height(50)

        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                        height: UIScreen.main.bounds.height + descriptionLabel.frame.height - 250)

    }

}
