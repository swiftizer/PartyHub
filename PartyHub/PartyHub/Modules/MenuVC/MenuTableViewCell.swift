//
//  MenuTableViewCell.swift
//  PartyHub
//
//  Created by juliemoorled on 14.08.2022.
//

import UIKit
import PinLayout

final class MenuTableViewCell: UITableViewCell {

    // MARK: - Internal properties

    var eventName: String = "Event Name"
    var distance: Double = 0.0
    var participants: Int = 0
    var eventImage = UIImage()

    // MARK: - Private properties

    private let cellContainerView = UIView()
    private let eventImageView = UIImageView()
    private let titleLabel = UILabel()
    private let distanceLabel = UILabel()
    private let participantsLabel = UILabel()
    private let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    private let distanceImageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
    private let participantsImageView = UIImageView(image: UIImage(systemName: "person.2"))

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        setUpLayout()
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            cellContainerView.backgroundColor = .systemGray5
        } else {
            cellContainerView.backgroundColor = .systemBackground
        }
    }
}

extension MenuTableViewCell {

    // MARK: - Private methods

    private func setUpLayout() {

        let descriptionHeight: CGFloat = 20

        cellContainerView.pin
            .top(6)
            .left(12)
            .right(12)
            .bottom(6)

        eventImageView.pin
            .top(16)
            .left(16)
            .bottom(16)
            .width(cellContainerView.frame.height - 32)

        titleLabel.pin
            .top(frame.height/4)
            .left(eventImageView.frame.maxX + 24)
            .width(frame.width*0.6)
            .height(25)

        chevronImageView.pin
            .right(20)
            .height(descriptionHeight)
            .vCenter()

        distanceImageView.pin
            .top(titleLabel.frame.maxY + 24)
            .left(titleLabel.frame.minX)
            .height(descriptionHeight)

        distanceLabel.pin
            .top(distanceImageView.frame.minY)
            .left(distanceImageView.frame.maxX + 6)
            .height(descriptionHeight)
            .width(frame.width*0.25)

        participantsImageView.pin
            .top(distanceLabel.frame.minY)
            .left(distanceLabel.frame.maxX + 6)
            .height(descriptionHeight)

        participantsLabel.pin
            .top(participantsImageView.frame.minY)
            .left(participantsImageView.frame.maxX + 6)
            .height(descriptionHeight)
            .width(frame.width*0.15)

    }

    func setUpCell(with event: Event, distance: Double) {
        backgroundColor = .clear
        selectionStyle = .none

        ImageManager.shared.downloadImage(with: event.imageName) { result in
            switch result {
            case .success(let downloadedImage):
                self.eventImageView.image = downloadedImage
                break

            case .failure:
                break
            }
        }

        eventName = event.title
        self.distance = distance
        participants = event.countOfParticipants

        setUpCellContainerView()
        setUpEventImageView()
        setUp(label: titleLabel, of: 17, weight: .medium, text: eventName)
        setUp(icon: chevronImageView, color: .systemGray)
        setUp(icon: distanceImageView)
        setUp(label: distanceLabel, text: "\(round(100 * distance) / 100)" + " km away")
        setUp(icon: participantsImageView)
        setUp(label: participantsLabel, text: "\(participants)")
    }

    private func setUpCellContainerView() {
        addSubview(cellContainerView)
        cellContainerView.layer.cornerRadius = 15
        cellContainerView.backgroundColor = .systemBackground
        cellContainerView.dropShadow()
    }

    private func setUpEventImageView() {
        cellContainerView.addSubview(eventImageView)
        eventImageView.backgroundColor = .systemGray6
        eventImageView.layer.cornerRadius = 15
        eventImageView.layer.masksToBounds = true
    }

    private func setUp(icon: UIImageView, color: UIColor = .label) {
        cellContainerView.addSubview(icon)
        icon.tintColor = color
    }

    private func setUp(label: UILabel, of size: CGFloat = 15, weight: UIFont.Weight = .regular, text: String) {
        cellContainerView.addSubview(label)
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = .label
        label.textAlignment = .left
    }
}
