//
//  AddTableViewCell.swift
//  PartyHub
//
//  Created by Dinar Garaev on 12.08.2022.
//

import UIKit
import PinLayout

final class AddTableViewCell: UITableViewCell {

    // MARK: - Public Properties

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemIndigo
        view.layer.cornerRadius = 15
        return view
    }()

    // MARK: - Private Properties

    private let plusImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "plus"))
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .white
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15)
        label.text = "Создать мероприятие"
        label.textAlignment = .left
        return label
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContainer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            containerView.backgroundColor = .systemIndigo.withAlphaComponent(0.4)
        } else {
            containerView.backgroundColor = .systemIndigo
        }
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

    // MARK: - Private Methods

    private func setupContainer() {
        selectionStyle = .none
        backgroundColor = .clear

        addSubview(containerView)
        containerView.addSubview(plusImageView)
        containerView.addSubview(titleLabel)
        dropShadow()
    }

    private func setupLayout() {
        containerView.pin
            .top(14)
            .left(12)
            .right(12)
            .bottom(8)

        plusImageView.pin
            .width(14)
            .height(14)
            .left(12)
            .vCenter()

        titleLabel.pin
            .after(of: plusImageView)
            .vCenter()
            .width(frame.width - plusImageView.frame.width - 24)
            .height(24)
            .marginLeft(12)
    }
}
