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
    weak var adapter: MenuTableViewAdapter?

    // MARK: - Private properties

    private let cellContainerView = UIView()
    private let eventImageView = UIImageView()
    private let titleLabel = UILabel()
    private let distanceLabel = UILabel()
    private let participantsLabel = UILabel()
    private let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    private let distanceImageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
    private let participantsImageView = UIImageView(image: UIImage(systemName: "person.2"))
    private var event: Event?
    private let deleteButton = UIButton()
    private let activityIndicator = LoadindIndicatorView()

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
            .top(12)
            .left(12)
            .right(12)
            .bottom(0)

        eventImageView.pin
            .top(16)
            .left(16)
            .bottom(16)
            .width(cellContainerView.frame.height - 32)

        titleLabel.pin
            .vCenter(-20)
            .left(eventImageView.frame.maxX + 24)
            .maxWidth(frame.width*0.5)
            .maxHeight(50)
            .sizeToFit(.width)

        chevronImageView.pin
            .right(20)
            .height(descriptionHeight)
            .vCenter()

        distanceImageView.pin
            .bottom(30)
            .left(titleLabel.frame.minX)
            .height(descriptionHeight)

        distanceLabel.pin
            .bottom(30)
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

        deleteButton.pin
            .top()
            .right()
            .width(50)
            .height(50)

        activityIndicator.pinToRootView(rootView: eventImageView, frame: eventImageView.frame)
    }

    func setUpCell(with event: Event, distance: Double) {
        backgroundColor = .clear
        selectionStyle = .none

        self.event = event

        eventName = event.title
        self.distance = distance
        participants = event.countOfParticipants

        deleteButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        deleteButton.tintColor = .red
        deleteButton.addTarget(self, action: #selector(deleteEvent), for: .touchUpInside)

        var koef = 100.0
        switch distance {
        case 10..<100:
            koef = 10
        case 100...:
            koef = 1
        default:
            koef = 100
        }

        setUpCellContainerView()
        setUpEventImageView()
        setUp(label: titleLabel, of: 17, weight: .medium, text: eventName)
        setUp(icon: chevronImageView, color: .systemGray)
        setUp(icon: distanceImageView)
        setUp(label: distanceLabel, text: (koef != 1 ? "\(round(koef * distance) / koef)" : "\(Int(distance))") + " км от вас")
        setUp(icon: participantsImageView)
        setUp(label: participantsLabel, text: "\(participants)")

        activityIndicator.start()
        ImageManager.shared.downloadImage(with: event.imageName) { result in
            switch result {
            case .success(let downloadedImageRes):
                if downloadedImageRes.way == .cashe {
                    self.activityIndicator.stopInstantly()
                } else {
                    self.activityIndicator.stopSuccess()
                }

                self.eventImageView.image = downloadedImageRes.image
            case .failure:
                self.activityIndicator.stopFailure()
            }
        }

        guard let UID = AuthManager.shared.currentUser()?.uid else {
            deleteButton.isHidden = true
            return
        }

        if UID == AuthManager.shared.adminUid || (!(adapter?.needAddSection ?? true)) && (adapter?.isCreatedTV ?? false) {
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
            print(deleteButton.isHidden)
        }
    }

    private func setUpCellContainerView() {
        addSubview(cellContainerView)
        cellContainerView.layer.cornerRadius = 15
        cellContainerView.backgroundColor = .systemBackground
        cellContainerView.dropShadow()
    }

    private func setUpEventImageView() {
        cellContainerView.addSubview(eventImageView)
        cellContainerView.addSubview(deleteButton)
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
        label.numberOfLines = 0
    }

    @objc
    private func deleteEvent() {
        guard let event = event else {
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name("MenuTableViewCell.AdminDeleteEventStart.Sirius.PartyHub"), object: nil)
        EventManager.shared.adminDeleteEvent(event: event) { res in
            switch res {
            case .success:
                NotificationCenter.default.post(name: NSNotification.Name("MenuTableViewCell.AdminDeleteEventSuccess.Sirius.PartyHub"), object: nil)
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            case .failure(let error):
                debugPrint(error.rawValue)
                NotificationCenter.default.post(name: NSNotification.Name("MenuTableViewCell.AdminDeleteEventFailure.Sirius.PartyHub"), object: nil)
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
    }
}
