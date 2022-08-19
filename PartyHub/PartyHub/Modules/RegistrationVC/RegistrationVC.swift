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
        case enter
        case alert
    }

    var navigation: ((Navigation) -> Void)?

    // MARK: - Private Properties

    private let mainView = RegistrationView()

    // MARK: - Life Cycle

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Actions

    @objc
    private func backAction() {
        FeedbackGenerator.shared.feedbackGeneration(.medium)
        self.navigation?(.back)
    }

    // MARK: - Private Methods

    private func setupUI() {
        mainView.delegate = self

        let backNavigationItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle"),
            style: .plain,
            target: self,
            action: #selector(backAction)
        )

        backNavigationItem.tintColor = .label
        navigationItem.rightBarButtonItem = backNavigationItem
    }
}

// MARK: - RegistrationViewDelegate

extension RegistrationVC: RegistrationViewDelegate {
    func showAlert() {
        self.navigation?(.alert)
    }

    func registerationButtonTapped() {
        FeedbackGenerator.shared.feedbackGeneration(.medium)
        self.navigation?(.enter)
    }
}
