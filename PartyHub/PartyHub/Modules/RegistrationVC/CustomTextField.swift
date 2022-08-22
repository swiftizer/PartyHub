//
//  CustomTextField.swift
//  PartyHub
//
//  Created by Dinar Garaev on 18.08.2022.
//

import UIKit

final class CustomTextField: UITextField {

    enum TypeField {
        case emailTextField
        case passwordTextField
        case confirmPasswordTextField
    }

    // MARK: - Initialization

    init(type: TypeField) {
        super.init(frame: .zero)
        configureUI()
        switch type {
        case .emailTextField:
            attributedPlaceholder = NSAttributedString(
                string: "Email",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.4)]
            )
            textContentType = .emailAddress
        case .passwordTextField:
            attributedPlaceholder = NSAttributedString(
                string: "Пароль",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.4)]
            )
            isSecureTextEntry = true
            textContentType = .oneTimeCode
        case .confirmPasswordTextField:
            attributedPlaceholder = NSAttributedString(
                string: "Повторить пароль",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.4)]
            )
            isSecureTextEntry = true
            textContentType = .oneTimeCode
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        font = UIFont.boldSystemFont(ofSize: 16)
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        layer.cornerRadius = 15
        autocorrectionType = .no
        leftViewMode = .always
        keyboardType = .default
        returnKeyType = .default
        clearButtonMode = .whileEditing
        backgroundColor = .systemGray4
        textColor = .label
        tintColor = .label
        autocapitalizationType = .none
        dropShadow()
    }
}
