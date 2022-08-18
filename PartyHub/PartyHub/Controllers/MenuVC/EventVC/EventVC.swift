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
    }

    private func setUpLayout() {
        eventImageView.pin
            .top()
            .left()
            .right()
            .height(view.frame.height/2)
    }

}
