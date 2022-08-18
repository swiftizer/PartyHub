//
//  RegistrationView.swift
//  PartyHub
//
//  Created by Dinar Garaev on 16.08.2022.
//

import UIKit
import PinLayout

protocol RegistrationViewDelegate: AnyObject {
    func registerationButtonTapped()
}

/// Кастомная view регистрации
final class RegistrationView: UIView {

    weak var delegate: RegistrationViewDelegate?

    // MARK: - Private Properties

    private let firstNameTextField = CustomTextField(type: .firstNameTextField)
    private let lastNameTextField = CustomTextField(type: .lastNameTextField)
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
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
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
        delegate?.registerationButtonTapped()
    }

    // MARK: - Private Methods

    private func setupUI() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        addGestureRecognizer(tapGesture)
        backgroundColor = .systemBackground
        addSubview(firstNameTextField)
        addSubview(lastNameTextField)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(registerButton)
        addSubview(confirmPasswordTextField)
    }

    private func setupLayout() {
        firstNameTextField.pin
            .top(pin.safeArea.top + 24)
            .left(pin.safeArea.left + 20)
            .right(pin.safeArea.right + 20)
            .height(50)

        lastNameTextField.pin
            .below(of: firstNameTextField, aligned: .left)
            .marginTop(12)
            .width(of: firstNameTextField)
            .height(50)

        emailTextField.pin
            .below(of: lastNameTextField, aligned: .left)
            .marginTop(12)
            .width(of: lastNameTextField)
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
