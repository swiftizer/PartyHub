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
        case back
        case go
    }

    var navigation: ((Navigation) -> Void)?

    // MARK: - Private properties

    private struct Constants {
        static let labelWidthMultiplier: CGFloat = 0.85
        static let labelHeight: CGFloat = 24
        static let buttonHeight: CGFloat = 50
    }

    private let event: Event
    private let eventImageView = UIImageView()
    private let dateLabel = UILabel()
    private let addressLabel = UILabel()
    private let priceLabel = UILabel()
    private let participantsLabel = UILabel()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

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
        button.backgroundColor = .systemIndigo.withAlphaComponent(0.8)
        button.setTitle("Иду!", for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(didTapMapButton), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()

    private let dateImageName = "clock"
    private let addressImageName = "mappin.and.ellipse"
    private let priceImageName = "dollarsign.circle"
    private let participantsImageName = "person.2"
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

        setupImage()
        setupUI()
        setupNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
        setUpLayout()
    }

    // MARK: - Actions

    @objc
    private func didTapMapButton() {
        navigation?(.go)
    }

    @objc
    private func backAction() {
        FeedbackGenerator.shared.customFeedbackGeneration(.medium)
        navigation?(.back)
    }

    // MARK: - Private methods

    private func setupUI() {
        let eventPlace = String(describing: event.place.split(separator: "|")[0])
        eventNameLabel.text = event.title
        descriptionLabel.text = event.description
        setupIconWithLabel(label: dateLabel,
                           iconName: dateImageName,
                           text: "\(event.begin) - \(event.end)")
        setupIconWithLabel(label: addressLabel,
                           iconName: addressImageName,
                           text: eventPlace)
        setupIconWithLabel(label: priceLabel,
                           iconName: priceImageName,
                           text: (event.cost == 0) ? "FREE" : "\(event.cost)")
        setupIconWithLabel(label: participantsLabel,
                           iconName: participantsImageName,
                           text: "\(event.countOfParticipants)")

        view.addSubview(eventImageView)
        view.addGradient(
            firstColor: .systemBackground.withAlphaComponent(0.1),
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
            case .success(let image):
                self?.eventImageView.image = image
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

        goForEventButton.pin
            .top(descriptionLabel.frame.maxY + 12)
            .hCenter()
            .width(view.frame.width * Constants.labelWidthMultiplier)
            .height(Constants.buttonHeight)

        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                        height: UIScreen.main.bounds.height + descriptionLabel.frame.height - 150)

    }
}
