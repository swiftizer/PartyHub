//
//  ProfileVC.swift
//  PartyHub
//
//  Created by juliemoorled on 14.08.2022.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {
    enum Navigation {
        case exit
    }

    var navigation: ((Navigation) -> Void)?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Actions
    
    @objc
    private func exitButtonTapped() {
        do {
            try Auth.auth().signOut()
        } catch (let error) {
            print(error.localizedDescription)
        }
        FeedbackGenerator.shared.feedbackGeneration(.medium)
        navigation?(.exit)
    }

    // MARK: - Private Methods

    private func setupUI() {
        let exitNavigationItem = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(exitButtonTapped)
        )

        exitNavigationItem.tintColor = .label
        navigationItem.rightBarButtonItem = exitNavigationItem
    }
}
