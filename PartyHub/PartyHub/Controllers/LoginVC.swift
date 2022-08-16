//
//  UnloggedProfileVC.swift
//  PartyHub
//
//  Created by Dinar Garaev on 16.08.2022.
//

import UIKit

final class LoginVC: UIViewController {

    enum Navigation {
        case register
        case login
    }

    var navigation: ((Navigation) -> Void)?

    // MARK: - Private Properties

    private let mainView = LoginView()
    private let generator = UIImpactFeedbackGenerator(style: .medium)

    // MARK: - Life Cycle

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        generator.prepare()
        mainView.delegate = self
    }
}

// MARK: - LoginViewDelegate

extension LoginVC: LoginViewDelegate {
    func loginingButtonTapped() {
        generator.impactOccurred(intensity: 0.6)
        navigation?(.login)
    }

    func registrationButtonTapped() {
        generator.impactOccurred(intensity: 0.6)
        navigation?(.register)
    }
}
