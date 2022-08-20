//
//  EventVC.swift
//  PartyHub
//
//  Created by juliemoorled on 18.08.2022.
//

import UIKit
import PinLayout

final class EventVC: UIViewController {

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

    private struct Constants {
        static let labelWidthMultiplier: CGFloat = 0.85
        static let labelHeight: CGFloat = 24
        static let buttonHeight: CGFloat = 50
    }

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
    }

    // MARK: - Private methods

    @objc private func didTapMapButton() {
        // open maps
    }

    @objc private func didTapFavoriteButton() {
        if isFavorite {
            isFavorite = false
        } else {
            isFavorite = true
        }
        setUpFavoriteButton()
        // make event favorite
    }

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
        setUpFavoriteButton()
    }

    private func setUpFavoriteButton() {
        let favoriteButton = UIBarButtonItem(image:
                                                UIImage(systemName: isFavorite ? favoriteImageName : notFavoriteImageName),
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
        mapButton.backgroundColor = .systemGray5
        mapButton.setTitle("Show on map", for: .normal)
        mapButton.layer.cornerRadius = 15
        mapButton.addTarget(self, action: #selector(didTapMapButton), for: .touchUpInside)
        mapButton.tintColor = .label
    }

    private func setUpLayout() {

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
            .width(view.frame.width * Constants.labelWidthMultiplier)
            .height(Constants.labelHeight)

        let labelsWithImages = [dateLabel, addressLabel, priceLabel, participantsLabel]
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

        mapButton.pin
            .top(descriptionLabel.frame.maxY + 12)
            .hCenter()
            .width(view.frame.width * Constants.labelWidthMultiplier)
            .height(Constants.buttonHeight)

        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                        height: UIScreen.main.bounds.height + descriptionLabel.frame.height - 250)

    }

}
