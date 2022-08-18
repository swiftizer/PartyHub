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
        resignFirstResponders()

        if !validateTextFields() {
            invalidAnimation(for: registerButton)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }

        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }

        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] _, error in
            guard error == nil else {
                debugPrint(error?.localizedDescription ?? "Error")
                return
            }

            self?.delegate?.registerationButtonTapped()
        }
    }

    // MARK: - Private Methods

    private func resignFirstResponders() {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }

    private func validateTextFields() -> Bool {
        // TODO: - это пиздец, надо фиксить
        [firstNameTextField, lastNameTextField].forEach {
            if !($0.text?.isValidName ?? false) {
                repaintBorder(for: $0, borderWidth: 1, color: .red.withAlphaComponent(0.6))
            } else {
                repaintBorder(for: $0, borderWidth: 0, color: .clear)
            }
        }

        if !(emailTextField.text?.isValidEmailAddress ?? false) {
            repaintBorder(for: emailTextField, borderWidth: 1, color: .red.withAlphaComponent(0.6))
        } else {
            repaintBorder(for: emailTextField, borderWidth: 0, color: .clear)
        }

        if let password = passwordTextField.text,
           let repeatePassword = confirmPasswordTextField.text,
           !password.isValidPassword,
           !repeatePassword.isValidPassword {
            repaintBorder(for: passwordTextField, borderWidth: 1, color: .red.withAlphaComponent(0.6))
            repaintBorder(for: confirmPasswordTextField, borderWidth: 1, color: .red.withAlphaComponent(0.6))
            invalidAnimation(for: registerButton)
            showAlertUserRegiestrationError()
            return false
        } else {
            repaintBorder(for: passwordTextField, borderWidth: 0, color: .clear)
            repaintBorder(for: confirmPasswordTextField, borderWidth: 0, color: .clear)
        }

        if passwordTextField.text != confirmPasswordTextField.text {
            repaintBorder(for: passwordTextField, borderWidth: 1, color: .red.withAlphaComponent(0.6))
            repaintBorder(for: confirmPasswordTextField, borderWidth: 1, color: .red.withAlphaComponent(0.6))
            invalidAnimation(for: registerButton)
            showAlertUserRegiestrationError()
            return false
        } else {
            repaintBorder(for: passwordTextField, borderWidth: 0, color: .clear)
            repaintBorder(for: confirmPasswordTextField, borderWidth: 0, color: .clear)
        }

        guard let firstName = firstNameTextField.text,
              firstName.isValidName,
              let secondName = lastNameTextField.text,
              secondName.isValidName,
              let email = emailTextField.text,
              email.isValidEmailAddress,
              let password = passwordTextField.text,
              let repeatepassword = confirmPasswordTextField.text,
              !password.isEmpty,
              password == repeatepassword
        else {
            invalidAnimation(for: registerButton)
            showAlertUserRegiestrationError()
            return false
        }

        return true
    }

    private func showAlertUserRegiestrationError() {
        let alert = UIAlertController(
            title: "Woops",
            message: "Please enter all information to create a new account.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow})
                .first
        keyWindow?.rootViewController?.presentedViewController?.present(
            alert,
            animated: true,
            completion: nil
        )
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

extension RegistrationView {

    // MARK: - Animation

    private func repaintBorder(for view: UIView, borderWidth: CGFloat, color: UIColor) {
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = color.cgColor
    }
}
