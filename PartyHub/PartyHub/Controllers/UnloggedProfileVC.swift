//
//  UnloggedProfileVC.swift
//  PartyHub
//
//  Created by Dinar Garaev on 16.08.2022.
//

import UIKit
import PinLayout

final class UnloggedProfileVC: UIViewController {

    enum Navigation {
        case register
        case login
    }

    var navigation: ((Navigation) -> Void)?

    // MARK: - Private Properties

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.dropShadow(shadowColor: UIColor(hexString: "#000000", alpha: 0.3), shadowOpacity: 1, shadowOffset: CGSize(width: 0, height: 0.5), shadowRadius: 0)
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.4)]
        )
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.dropShadow(shadowColor: UIColor(hexString: "#000000", alpha: 0.3), shadowOpacity: 1, shadowOffset: CGSize(width: 0, height: 0.5), shadowRadius: 0)
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.4)]
        )
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 15
        button.tintColor = .label
        button.dropShadow(shadowColor: UIColor(hexString: "#000000", alpha: 0.3), shadowOpacity: 1, shadowOffset: CGSize(width: 0, height: 0.5), shadowRadius: 0)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add account", for: .normal)
        button.backgroundColor = .systemGray6.withAlphaComponent(0.6)
        button.layer.cornerRadius = 15
        button.tintColor = .label
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        button.dropShadow(shadowColor: UIColor(hexString: "#000000", alpha: 0.3), shadowOpacity: 1, shadowOffset: CGSize(width: 0, height: 0.5), shadowRadius: 0)
        return button
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    // MARK: - Actions

    @objc
    private func loginButtonTapped() {
        navigation?(.login)
    }

    @objc
    private func registerButtonTapped() {
        navigation?(.register)
    }

    @objc
    private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    // MARK: - Private Methods

    private func setupUI() {
        [emailTextField, passwordTextField].forEach {
            $0.backgroundColor = .systemGray6
            $0.tintColor = .label
            $0.textColor = .label
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
            $0.layer.cornerRadius = 15
            $0.autocorrectionType = .no
            $0.leftViewMode = .always
            $0.keyboardType = .default
            $0.returnKeyType = .default
            $0.clearButtonMode = .whileEditing
        }
        view.backgroundColor = .systemBackground
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    private func setupLayout() {
        emailTextField.pin
            .top(view.pin.safeArea.top + 24)
            .left(view.pin.safeArea.left + 20)
            .right(view.pin.safeArea.right + 20)
            .height(50)

        passwordTextField.pin
            .below(of: emailTextField, aligned: .left)
            .marginTop(12)
            .width(of: emailTextField)
            .height(50)

        loginButton.pin
            .below(of: passwordTextField, aligned: .left)
            .marginTop(12)
            .width(of: passwordTextField)
            .height(50)

        registerButton.pin
            .below(of: loginButton, aligned: .left)
            .marginTop(12)
            .width(of: loginButton)
            .height(50)
    }
}
