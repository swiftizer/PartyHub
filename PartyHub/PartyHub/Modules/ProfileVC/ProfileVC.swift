//
//  ProfileVC.swift
//  PartyHub
//
//  Created by juliemoorled on 14.08.2022.
//

import UIKit
import FirebaseAuth
import PinLayout

class ProfileVC: UIViewController {

    // MARK: - Internal properties

    enum Navigation {
        case exit
    }

    var navigation: ((Navigation) -> Void)?
    let favoriteEventsVC = FavoriteEventsVC()
    let createdEventsVC = CreatedEventsVC()
    
    // MARK: - Private properties

    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let toggleView = ProfileToggleView()
    private let scrollView = UIScrollView()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEmail()
        setupDelegates()
        addChildren()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupEmail()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpLayout()
    }

    // MARK: - Actions

    @objc
    private func exitButtonTapped() {
        AuthManager.shared.signOut { [weak self] result in
            switch result {
            case .success:
                FeedbackGenerator.shared.customFeedbackGeneration(.medium)
                NotificationCenter.default.post(name: NSNotification.Name("AuthManager.SignOut.Sirius.PartyHub"), object: nil)
                self?.navigation?(.exit)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
        tabBarController?.selectedIndex = 0
    }

    // MARK: - Private Methods

    private func setupEmail() {
        guard let email = AuthManager.shared.currentUser()?.email else { return }
        nameLabel.text = email
    }

    private func setupUI() {
        let exitNavigationItem = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(exitButtonTapped)
        )

        view.addSubview(iconImageView)
//        iconImageView.backgroundColor = .systemIndigo
//        iconImageView.layer.cornerRadius = 15

        iconImageView.layer.masksToBounds = true
        iconImageView.image = UIImage(systemName: "person.crop.circle")
        iconImageView.tintColor = .systemIndigo
        iconImageView.contentMode = .scaleToFill

        view.addSubview(nameLabel)
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center

        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        exitNavigationItem.tintColor = .label
        navigationItem.rightBarButtonItem = exitNavigationItem

        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        view.addSubview(toggleView)
    }

    private func setUpLayout() {
        let basicPadding: CGFloat = 12
        let imageViewWidth: CGFloat = view.frame.width / 4

        iconImageView.pin
            .top(view.safeAreaInsets.top + basicPadding*2)
            .hCenter()
            .width(imageViewWidth)
            .height(imageViewWidth)

        nameLabel.pin
            .top(iconImageView.frame.maxY + basicPadding)
            .hCenter(to: iconImageView.edge.hCenter)
            .width(view.frame.width*0.8)
            .height(24)

        scrollView.pin
            .top(nameLabel.frame.maxY + basicPadding*2)
            .right()
            .left()
            .bottom()
        scrollView.contentSize = CGSize(width: view.width * 2, height: scrollView.height)

        toggleView.pin
            .top(nameLabel.frame.maxY + basicPadding)
            .width(view.frame.width)
            .height(55)
    }

    private func setupDelegates() {
        scrollView.delegate = self
        toggleView.delegate = self
    }

    private func addChildren() {
        addChild(favoriteEventsVC)
        scrollView.addSubview(favoriteEventsVC.view)
        favoriteEventsVC.view.frame = CGRect(
            x: 0,
            y: 0,
            width: scrollView.width,
            height: scrollView.height
        )
        favoriteEventsVC.didMove(toParent: self)

        addChild(createdEventsVC)
        scrollView.addSubview(createdEventsVC.view)
        createdEventsVC.view.frame = CGRect(
            x: view.width,
            y: 0,
            width: scrollView.width,
            height: scrollView.height
        )
        createdEventsVC.didMove(toParent: self)
    }
}

// MARK: - UIScrollViewDelegate

extension ProfileVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.width - 100) {
            toggleView.update(for: .created)
        } else {
            toggleView.update(for: .favorites)
        }
    }
}

// MARK: - ProfileToggleViewDelegate

extension ProfileVC: ProfileToggleViewDelegate {
    func profileToggleViewDidTapFavorites(_ toggleView: ProfileToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
    }

    func profileToggleViewDidTapCreated(_ toggleView: ProfileToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
    }
}
