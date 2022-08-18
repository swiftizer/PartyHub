//
//  ProfileVC.swift
//  PartyHub
//
//  Created by juliemoorled on 14.08.2022.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let exitNavigationItem = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(exitButtonTapped)
        )

        exitNavigationItem.tintColor = .label
        navigationItem.rightBarButtonItem = exitNavigationItem
    }

    @objc
    private func exitButtonTapped() {
        Auth.auth().currentUser?.delete(completion: { error in
            if error != nil {
                // An error happened.
            } else {
                // Account deleted.
            }
        })
    }
}
