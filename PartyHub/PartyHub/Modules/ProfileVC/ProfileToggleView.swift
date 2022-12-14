//
//  ProfileToggleView.swift
//  PartyHub
//
//  Created by juliemoorled on 21.08.2022.
//

import UIKit
import PinLayout

protocol ProfileToggleViewDelegate: AnyObject {
    func profileToggleViewDidTapFavorites(_ toggleView: ProfileToggleView)
    func profileToggleViewDidTapCreated(_ toggleView: ProfileToggleView)
}

final class ProfileToggleView: UIView {

    // MARK: - Internal properties

    weak var delegate: ProfileToggleViewDelegate?

    enum State {
        case favorites
        case created
    }

    var state: State = .favorites

    // MARK: - Private properties

    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemIndigo
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()

    private lazy var favoritesButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Выбранные", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(favoritesButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var createdButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Созданные", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(createdButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(indicatorView)
        addSubview(favoritesButton)
        addSubview(createdButton)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        setupFrames()
    }

    // MARK: - Actions

    @objc
    private func favoritesButtonTapped() {
        update(for: .favorites)
        delegate?.profileToggleViewDidTapFavorites(self)
    }

    @objc
    private func createdButtonTapped() {
        update(for: .created)
        delegate?.profileToggleViewDidTapCreated(self)
    }

    // MARK: - Methods

    func update(for state: State) {
        NotificationCenter.default.post(name: NSNotification.Name("ProfileToggleView.Update.Sirius.PartyHub"), object: nil)
        self.state = state
        UIView.animate(withDuration: 0.3) {
            self.layoutIndicator()
        }
    }

    // MARK: - Private Merhods

    private func setupFrames() {
        favoritesButton.pin
            .top()
            .width(frame.width/2)
            .left()
            .height(40)
        createdButton.pin
            .top()
            .width(frame.width/2)
            .right()
            .height(40)
        layoutIndicator()
    }

    private func layoutIndicator() {
        switch state {
        case .favorites:
            indicatorView.pin
                .top(favoritesButton.bottom)
                .width(frame.width/2)
                .left()
                .height(3)
        case .created:
            indicatorView.pin
                .top(createdButton.bottom)
                .width(frame.width/2)
                .right()
                .height(3)
        }
    }
}
