//
//  LoginView.swift
//  PartyHub
//
//  Created by Dinar Garaev on 17.08.2022.
//

import UIKit
import PinLayout
import FirebaseAuth

protocol LoginViewDelegate: AnyObject {
    func loginingButtonTapped()
    func registrationButtonTapped()
}

/// Кастомная view логина
final class LoginView: UIView {

    weak var delegate: LoginViewDelegate?

    // MARK: - Private Properties

    private var isFirstTouch: Bool = true
    private let emailTextField = CustomTextField(type: .emailTextField)
    private let passwordTextField = CustomTextField(type: .passwordTextField)

    // MARK: - Computed Properties

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
        setupFirstLayout()
    }

    // MARK: - Actions

    @objc
    private func loginButtonTapped() {
        if isFirstTouch {
            setupSecondLayout()
            isFirstTouch = false
        } else {
            guard let email = emailTextField.text, let password = passwordTextField.text else {
                return
            }
            AuthManager.shared.signIn(email: email, password: password) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.delegate?.loginingButtonTapped()
                case .failure:
                    FeedbackGenerator.shared.errorFeedbackGenerator()
                    self.invalidAnimation(for: self.loginButton)
                    self.repaintBorder(
                        for: [self.emailTextField, self.passwordTextField],
                        borderWidth: 1,
                        color: .red.withAlphaComponent(0.6)
                    )
                }
            }
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
        [loginButton, registerButton].forEach {
            $0.backgroundColor = .systemGray5
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

        addBlur(style: .regular, alpha: 0.86)
        backgroundColor = .clear
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(registerButton)
    }

    private func setupSecondLayout() {
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
                .marginTop(28)
                .width(of: self.passwordTextField)
                .height(50)

            self.registerButton.pin
                .below(of: self.loginButton, aligned: .left)
                .marginTop(12)
                .width(of: self.loginButton)
                .height(50)
        }
    }

    private func setupFirstLayout() {
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
