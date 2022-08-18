//
//  EventVC.swift
//  PartyHub
//
//  Created by juliemoorled on 18.08.2022.
//

import UIKit
import PinLayout

final class EventVC: UIViewController {

    // MARK: - Private properties

    private let eventImageView = UIImageView()
    private let scrollView = UIScrollView()
    private let eventNameLabel = UILabel()
    private let dateLabel = UILabel()
    private let addressLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()

    private let dateImageName = "clock"
    private let addressImageName = "mappin.and.ellipse"
    private let priceImageName = "dollarsign.circle"

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBackground()
        setUpEventNameLabel()
        if let image = UIImage(systemName: dateImageName) {
            setUpIconWithLabel(icon: image, label: dateLabel,
                               text: "11pm Monday, 22 August 2022")
        }
        if let image = UIImage(systemName: addressImageName) {
            setUpIconWithLabel(icon: image, label: addressLabel,
                               text: "New Bar, 17 Lenina street, Sochi")
        }
        if let image = UIImage(systemName: priceImageName) {
            setUpIconWithLabel(icon: image, label: priceLabel,
                               text: "FREE")
        }

        // make navbar background invisible
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpLayout()
    }

    // MARK: - Private methods

    private func setUpBackground() {
        view.addSubview(eventImageView)
        eventImageView.backgroundColor = .systemIndigo
        view.addGradient(firstColor: .systemBackground.withAlphaComponent(0.1),
                         secondColor: .systemBackground)
        view.addSubview(scrollView)
    }

    private func setUpEventNameLabel() {
        scrollView.addSubview(eventNameLabel)
        eventNameLabel.text = "It's Friday I'm in love"
        eventNameLabel.font = .systemFont(ofSize: 28, weight: .semibold)
        eventNameLabel.textColor = .label
        eventNameLabel.textAlignment = .left
    }

    private func setUpIconWithLabel(icon: UIImage, label: UILabel, text: String) {
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

    private func setUpLayout() {

        let labelWidth: CGFloat = view.frame.width * 0.8
        let labelHeight: CGFloat = 24

        eventImageView.pin
            .top()
            .left()
            .right()
            .height(view.frame.height/2)

        scrollView.pin
            .all()

        eventNameLabel.pin
            .top(eventImageView.frame.maxY - 36)
            .hCenter()
            .width(labelWidth)
            .height(labelHeight)

        dateLabel.pin
            .top(eventNameLabel.frame.maxY + 12)
            .hCenter()
            .width(labelWidth)
            .height(labelHeight)

        addressLabel.pin
            .top(dateLabel.frame.maxY + 8)
            .hCenter()
            .width(labelWidth)
            .height(labelHeight)

        priceLabel.pin
            .top(addressLabel.frame.maxY + 8)
            .hCenter()
            .width(labelWidth)
            .height(labelHeight)

    }

}
