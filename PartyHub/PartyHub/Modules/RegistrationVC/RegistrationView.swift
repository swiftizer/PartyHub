//
//  RegistrationView.swift
//  PartyHub
//
//  Created by Dinar Garaev on 16.08.2022.
//

import UIKit
import PinLayout
import FirebaseAuth

protocol RegistrationViewDelegate: AnyObject {
    func registerationButtonTapped()
}

/// Кастомная view регистрации
final class RegistrationView: UIView {

    weak var delegate: RegistrationViewDelegate?

    // MARK: - Private Properties

    private let emailTextField = CustomTextField(type: .emailTextField)
    private let passwordTextField = CustomTextField(type: .passwordTextField)
    private let confirmPasswordTextField = CustomTextField(type: .confirmPasswordTextField)

    // MARK: - Computed Properties

    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Regiter", for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 15
        button.tintColor = .label
        button.dropShadow()
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
    private func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        if frame.origin.y != 0 {
            frame.origin.y = 0
        }
    }

    @objc
    private func registerButtonTapped() {
        resignFirstResponders()

        if !validateTextFields() {
            registerButton.invalidAnimation()
            FeedbackGenerator.shared.errorFeedbackGenerator()
            return
        }

        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        AuthManager.shared.registration(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.delegate?.registerationButtonTapped()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }

    // MARK: - Private Methods

    private func resignFirstResponders() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }

    private func validateTextFields() -> Bool {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text
        else {
            registerButton.invalidAnimation()
            return false
        }

        if !email.isValidEmailAddress {
            emailTextField.repaintBorder()
            registerButton.invalidAnimation()
        } else {
            emailTextField.repaintBorder(borderWidth: 0, color: .clear)
        }

        if !password.isValidPassword || !confirmPassword.isValidPassword || password != confirmPassword {
            passwordTextField.repaintBorder()
            confirmPasswordTextField.repaintBorder()
            registerButton.invalidAnimation()
            return false
        } else {
            passwordTextField.repaintBorder(borderWidth: 0, color: .clear)
            confirmPasswordTextField.repaintBorder(borderWidth: 0, color: .clear)
        }

        return true
    }

    private func setupUI() {
        backgroundColor = .systemBackground

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        addGestureRecognizer(tapGesture)

        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(registerButton)
        addSubview(confirmPasswordTextField)
    }

    private func setupLayout() {
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

        confirmPasswordTextField.pin
            .below(of: passwordTextField, aligned: .left)
            .marginTop(12)
            .width(of: passwordTextField)
            .height(50)

        registerButton.pin
            .below(of: confirmPasswordTextField, aligned: .left)
            .marginTop(28)
            .width(of: confirmPasswordTextField)
            .height(50)
    }

}
