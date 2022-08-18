//
//  String+Validation.swift
//  PartyHub
//
//  Created by Dinar Garaev on 18.08.2022.
//

import UIKit

extension String {
    var isValidName: Bool {
       let regEx = "[A-Za-z]{2,}"
       let test = NSPredicate(format: "SELF MATCHES %@", regEx)
       return test.evaluate(with: self)
    }

    var isValidEmailAddress: Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}"
            + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
            + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
            + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
            + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
            + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
            + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }

    var isValidPassword: Bool {
        let passwordRegEx = "[A-Za-z\\d]{4,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPredicate.evaluate(with: self)
    }
}
