//
//  RegistrationVC.swift
//  PartyHub
//
//  Created by Dinar Garaev on 16.08.2022.
//

import UIKit

final class RegistrationVC: UIViewController {
    enum Navigation {
        case back
        case registration
    }

    var navigation: ((Navigation) -> Void)?

    // MARK: - Private Properties

    private let mainView = RegistrationView()
    private let generator = UIImpactFeedbackGenerator(style: .medium)

    // MARK: - Life Cycle

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        generator.prepare()
        setupUI()
    }

    // MARK: - Actions

    @objc
    private func backAction() {
        generator.impactOccurred(intensity: 0.6)
        self.navigation?(.back)
    }

    // MARK: - Private Methods

    private func setupUI() {
        mainView.delegate = self

        let backNavigationItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(backAction)
        )
        backNavigationItem.tintColor = .label
        navigationItem.leftBarButtonItem = backNavigationItem
    }
}

// MARK: - RegistrationViewDelegate

extension RegistrationVC: RegistrationViewDelegate {
    func registerationButtonTapped() {
        generator.impactOccurred(intensity: 0.6)
        self.navigation?(.registration)
    }
}
