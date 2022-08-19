//
//  UnloggedProfileVC.swift
//  PartyHub
//
//  Created by Dinar Garaev on 16.08.2022.
//

import UIKit
import FirebaseAuth

final class LoginVC: UIViewController {
    enum Navigation {
        case register
        case enter
        case back
    }

    var navigation: ((Navigation) -> Void)?

    // MARK: - Private Properties

    private let mainView = LoginView()

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

// MARK: - LoginViewDelegate

extension LoginVC: LoginViewDelegate {
    func loginingButtonTapped() {
        FeedbackGenerator.shared.feedbackGeneration(.medium)
        navigation?(.enter)
    }

    func registrationButtonTapped() {
        FeedbackGenerator.shared.feedbackGeneration(.medium)
        navigation?(.register)
    }
}
