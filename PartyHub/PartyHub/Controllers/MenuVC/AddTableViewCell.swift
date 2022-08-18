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
        view.layer.cornerRadius = 15
        return view
    }()

    // MARK: - Private Properties

    private let plusImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "plus"))
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .label
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 15)

        label.text = "Add new event"
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
            containerView.backgroundColor = .systemGray5
        } else {
            containerView.backgroundColor = .systemBackground
        }
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

    // MARK: - Private Methods

    private func setupContainer() {
        setupBackgroundColor()
        selectionStyle = .none
        backgroundColor = .clear

        addSubview(containerView)
        containerView.addSubview(plusImageView)
        containerView.addSubview(titleLabel)
        dropShadow()
    }

    private func setupBackgroundColor() {
        switch traitCollection.userInterfaceStyle {
        case .light:
            containerView.backgroundColor = .systemBackground
        default:
            containerView.backgroundColor = .secondarySystemBackground
        }
    }

    private func setupLayout() {
        containerView.pin
            .top(14)
            .left(12)
            .right(12)
            .bottom(14)

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

public extension UIView {
    func showAnimation(_ completionBlock: @escaping () -> Void) {
      isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
}
