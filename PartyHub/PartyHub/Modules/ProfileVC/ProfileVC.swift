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
        case removeAccount
    }

    var navigation: ((Navigation) -> Void)?
    let favoriteEventsVC = FavoriteEventsVC()
    let createdEventsVC = CreatedEventsVC()

    // MARK: - Private properties

    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle"))
        imageView.layer.masksToBounds = true
        imageView.tintColor = .systemIndigo
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private lazy var removebutton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить аккаунт", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        button.tintColor = .red.withAlphaComponent(0.8)
        return button
    }()

    private let toggleView = ProfileToggleView()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        navigation?(.exit)
        tabBarController?.selectedIndex = 0
    }

    @objc
    private func removeButtonTapped() {
        presentAlert()
    }

    // MARK: - Private Methods

    private func presentAlert() {
        let alert = UIAlertController(title: "Подтверждение", message: "Вы уверены, что хотите удалить аккаунт?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        let removeAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.navigation?(.removeAccount)
        }
        alert.addAction(cancelAction)
        alert.addAction(removeAction)

        present(alert, animated: true, completion: nil)
    }

    private func setupEmail() {
        guard let email = AuthManager.shared.currentUser()?.email else { return }
        emailLabel.text = email
    }

    private func setupUI() {
        let exitNavigationItem = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(exitButtonTapped)
        )

        exitNavigationItem.tintColor = .label
        navigationItem.rightBarButtonItem = exitNavigationItem

        view.backgroundColor = .systemBackground

        view.addSubview(iconImageView)
        view.addSubview(emailLabel)
        view.addSubview(removebutton)
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

        emailLabel.pin
            .top(iconImageView.frame.maxY + basicPadding)
            .hCenter(to: iconImageView.edge.hCenter)
            .width(view.frame.width*0.8)
            .height(24)

        removebutton.pin
            .top(emailLabel.frame.maxY + basicPadding)
            .right(12)
            .left(12)
            .height(24)

        scrollView.pin
            .top(removebutton.frame.maxY + basicPadding*2)
            .right()
            .left()
            .bottom()
        scrollView.contentSize = CGSize(width: view.width * 2, height: scrollView.height)

        toggleView.pin
            .top(removebutton.frame.maxY + basicPadding)
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
