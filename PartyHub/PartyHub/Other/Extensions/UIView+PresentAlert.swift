//
//  UIView+PresentAlert.swift
//  PartyHub
//
//  Created by Dinar Garaev on 24.08.2022.
//

import UIKit

extension UIViewController {
    func presentAlert(with message: Error) {
        let alert = UIAlertController(title: "Oшибка", message: message.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Понятно", style: .cancel, handler: nil)

        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
