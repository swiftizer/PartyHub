//
//  LoginView.swift
//  PartyHub
//
//  Created by Dinar Garaev on 17.08.2022.
//

import UIKit
import PinLayout

protocol LoginViewDelegate: AnyObject {
    func loginingButtonTapped()
    func registrationButtonTapped()
}

/// Кастомная view логина
final class LoginView: UIView {

    weak var delegate: LoginViewDelegate?

    // MARK: - Private Properties

    private var isFirstTouch: Bool = true

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.4)]
        )
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
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
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add account", for: .normal)
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

    // MARK: - Actions

    @objc
    private func loginButtonTapped() {
        if isFirstTouch {
            emailTextField.pin
                .top(pin.safeArea.top + 24)
                .left(pin.safeArea.left + 20)
                .right(pin.safeArea.right + 20)
                .height(50)

            passwordTextField.pin
                .below(of: emailTextField, aligned: .left)
                .marginTop(12)
                .width(of: emailTextField)
                .height(50)

            UIView.animate(withDuration: 0.3) {
                self.loginButton.pin
                    .below(of: self.passwordTextField, aligned: .left)
                    .marginTop(12)
                    .width(of: self.passwordTextField)
                    .height(50)

                self.registerButton.pin
                    .below(of: self.loginButton, aligned: .left)
                    .marginTop(12)
                    .width(of: self.loginButton)
                    .height(50)
            }
            isFirstTouch = false
        } else {
            delegate?.loginingButtonTapped()
        }
    }

    @objc
    private func registerButtonTapped() {
        delegate?.registrationButtonTapped()
    }

    @objc
    private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        if frame.origin.y != 0 {
           frame.origin.y = 0
        }
    }

    // MARK: - Private Properties

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
            $0.dropShadow()
            $0.font = UIFont.boldSystemFont(ofSize: 16)
        }

        [loginButton, registerButton].forEach {
            $0.backgroundColor = .systemGray6
            $0.layer.cornerRadius = 15
            $0.tintColor = .label
            $0.dropShadow()
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        addGestureRecognizer(tapGesture)

        backgroundColor = .systemBackground
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(registerButton)
    }

    private func setupLayout() {
        if isFirstTouch {
            loginButton.pin
                .top(pin.safeArea.top + 24)
                .left(pin.safeArea.left + 20)
                .right(pin.safeArea.right + 20)
                .height(50)

            registerButton.pin
                .below(of: loginButton, aligned: .left)
                .marginTop(12)
                .width(of: loginButton)
                .height(50)
        }
    }

}
