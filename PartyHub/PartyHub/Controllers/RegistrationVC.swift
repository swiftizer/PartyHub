//
//  RegistrationVC.swift
//  PartyHub
//
//  Created by Dinar Garaev on 16.08.2022.
//

import UIKit
import Rswift

final class RegistrationVC: UIViewController {

    enum Navigation {
        case back
        case registration
    }

    var navigation: ((Navigation) -> Void)?

    // MARK: - Private Properties

    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.textColor = .label
        textField.tintColor = .label
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        textField.attributedPlaceholder = NSAttributedString(
            string: "First Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.4)]
        )
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.layer.cornerRadius = 15
        textField.autocorrectionType = .no
        textField.leftViewMode = .always
        textField.keyboardType = .default
        textField.returnKeyType = .default
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    private let secondNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.textColor = .label
        textField.tintColor = .label
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Second Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.4)]
        )
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.layer.cornerRadius = 15
        textField.autocorrectionType = .no
        textField.leftViewMode = .always
        textField.keyboardType = .default
        textField.returnKeyType = .default
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.textColor = .label
        textField.tintColor = .label
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.4)]
        )
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.layer.cornerRadius = 15
        textField.autocorrectionType = .no
        textField.leftViewMode = .always
        textField.keyboardType = .default
        textField.returnKeyType = .default
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.tintColor = .label
        textField.textColor = .label
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.4)]
        )
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.layer.cornerRadius = 15
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.leftViewMode = .always
        textField.keyboardType = .default
        textField.returnKeyType = .default
        textField.clearButtonMode = .whileEditing
        textField.textContentType = .oneTimeCode
        return textField
    }()

    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Regiter", for: .normal)
        button.backgroundColor = .systemGray6.withAlphaComponent(0.6)
        button.layer.cornerRadius = 15
        button.tintColor = .label
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
    private func backAction() {
        self.navigation?(.back)
    }

    @objc
    private func registerButtonTapped() {
        navigation?(.registration)
    }

    @objc
    private func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        firstNameTextField.resignFirstResponder()
        secondNameTextField.resignFirstResponder()
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
        view.backgroundColor = .systemBackground
        view.addSubview(firstNameTextField)
        view.addSubview(secondNameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)

        let backNavigationItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(backAction)
        )
        backNavigationItem.tintColor = .label
        navigationItem.leftBarButtonItem = backNavigationItem

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
        firstNameTextField.pin
            .top(view.pin.safeArea.top + 24)
            .left(view.pin.safeArea.left + 20)
            .right(view.pin.safeArea.right + 20)
            .height(50)

        secondNameTextField.pin
            .below(of: firstNameTextField, aligned: .left)
            .marginTop(12)
            .width(of: firstNameTextField)
            .height(50)

        emailTextField.pin
            .below(of: secondNameTextField, aligned: .left)
            .marginTop(12)
            .width(of: secondNameTextField)
            .height(50)

        passwordTextField.pin
            .below(of: emailTextField, aligned: .left)
            .marginTop(12)
            .width(of: emailTextField)
            .height(50)

        registerButton.pin
            .below(of: passwordTextField, aligned: .left)
            .marginTop(12)
            .width(of: passwordTextField)
            .height(50)
    }
}
