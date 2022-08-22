//
//  AddEventVC.swift
//  PartyHub
//
//  Created by Dinar Garaev on 19.08.2022.
//

import UIKit
import NVActivityIndicatorView

final class AddNewEventVC: UIViewController {
    enum Navigation {
        case back
        case registration
        case choosePlace
    }

    var navigation: ((Navigation) -> Void)?
    var choosedPoint = GeoPoint(name: nil, latitude: nil, longtitude: nil)

    // MARK: - Private Properties
    private let scrollView = UIScrollView()
    private let eventDescriptionTextView = UITextView()
    private var placeholderLabel = UILabel()
    private let separatorLabel = UILabel()
    private let eventImageView = EventImageView()
    private var didPhotoTakenFlag = false
    private let activityIndicatorView = UIView()
    private let successView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    private let rubleView = UIImageView()
    private var currentEditingDateTextField = UITextField()
    private var imagePicker: ImagePicker?
    private let datePicker = UIDatePicker()
    private let activityIndicator = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 67, height: 67),
        type: .ballClipRotateMultiple,
        color: UIColor.label,
        padding: 0
    )

    private let eventTitleTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Название",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.4)]
        )
        return textField
    }()

    private lazy var placeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemIndigo.withAlphaComponent(0.8)
        button.layer.cornerRadius = 15
        button.setTitle("Выбрать место", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setImage(UIImage(systemName: "map"), for: .normal)
        if #available(iOS 15, *) {
            button.titleEdgeInsets.left = 10
        }
        button.addTarget(self, action: #selector(choosePlace), for: .touchUpInside)
        return button

    }()

    private let beginDateTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Начало",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.4)]
        )
        textField.textAlignment = .center
        return textField
    }()

    private let endDateTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Окончание",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.4)]
        )
        textField.textAlignment = .center
        return textField
    }()

    private let costTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Стоимость (по умолчанию: 0)",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.4)]
        )
        return textField
    }()

    private let contactsTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Телефон / email / vk / Tg",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.4)]
        )
        return textField
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemIndigo.withAlphaComponent(0.8)
        button.layer.cornerRadius = 15
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.dropShadow(
            shadowColor: UIColor(hexString: "#000000").withAlphaComponent(0.3),
            shadowOpacity: 1,
            shadowOffset: CGSize(width: 0, height: 0.5),
            shadowRadius: 0
        )
        return button
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    // MARK: - Private Methods

    private func setupUI() {
        let backNavigationItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle"),
            style: .plain,
            target: self,
            action: #selector(backAction)
        )
        backNavigationItem.tintColor = .label
        navigationItem.rightBarButtonItem = backNavigationItem

        imagePicker = ImagePicker(presentationController: self, delegate: self)

        [eventTitleTextField, beginDateTextField, endDateTextField, costTextField, contactsTextField].forEach {
            $0.font = UIFont.boldSystemFont(ofSize: 16)
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
            $0.layer.cornerRadius = 15
            $0.autocorrectionType = .no
            $0.leftViewMode = .always
            $0.keyboardType = .default
            $0.returnKeyType = .done
            $0.clearButtonMode = .whileEditing
            $0.backgroundColor = .systemGray6
            $0.textColor = .label
            $0.tintColor = .label
            $0.delegate = self
        }

        beginDateTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        endDateTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))

        eventTitleTextField.addTarget(self, action: #selector(didStartEnterTitle), for: .editingDidBegin)

        costTextField.keyboardType = .numberPad
        costTextField.returnKeyType = .done
        costTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        costTextField.rightViewMode = .always

        eventDescriptionTextView.delegate = self

        placeholderLabel.text = "Описание"
        placeholderLabel.font = UIFont.boldSystemFont(ofSize: 16)
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 10, y: 8)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !eventDescriptionTextView.text.isEmpty

        separatorLabel.font = UIFont.boldSystemFont(ofSize: 20)
        separatorLabel.textColor = .label
        separatorLabel.textAlignment = .center
        separatorLabel.text = "-"

        eventDescriptionTextView.addSubview(placeholderLabel)
        eventDescriptionTextView.font = UIFont.boldSystemFont(ofSize: 16)
        eventDescriptionTextView.backgroundColor = .systemGray6
        eventDescriptionTextView.layer.cornerRadius = 15
        eventDescriptionTextView.tintColor = .label
        eventDescriptionTextView.textContainer.lineFragmentPadding = 10

        createDatePicker(for: beginDateTextField)
        createDatePicker(for: endDateTextField)

        eventImageView.layer.cornerRadius = 15
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapEventImageView))
        eventImageView.layer.masksToBounds = true
        eventImageView.addGestureRecognizer(tapGestureRecognizer)
        eventImageView.isUserInteractionEnabled = true
        eventImageView.image = UIImage(systemName: "camera.on.rectangle")
        eventImageView.tintColor = .label
        eventImageView.contentMode = .scaleToFill

        rubleView.layer.masksToBounds = true
        rubleView.image = UIImage(systemName: "rublesign.square")
        rubleView.tintColor = .label

        activityIndicatorView.backgroundColor = .systemGray4
        activityIndicatorView.layer.masksToBounds = true
        activityIndicatorView.layer.cornerRadius = 15
        activityIndicatorView.alpha = 0
        activityIndicator.alpha = 0
        activityIndicator.color = .label

        successView.tintColor = .label
        successView.alpha = 0

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))

        view.addSubview(scrollView)
        scrollView.addGestureRecognizer(tapGesture)
        scrollView.backgroundColor = .systemBackground
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height + 100 * 926 / UIScreen.main.bounds.height
        )

        scrollView.addSubview(eventImageView)
        scrollView.addSubview(eventTitleTextField)
        scrollView.addSubview(eventDescriptionTextView)
        scrollView.addSubview(placeButton)
        scrollView.addSubview(costTextField)
        scrollView.addSubview(contactsTextField)
        scrollView.addSubview(beginDateTextField)
        scrollView.addSubview(endDateTextField)
        scrollView.addSubview(addButton)
        scrollView.addSubview(separatorLabel)
        view.addSubview(activityIndicatorView)
        costTextField.addSubview(rubleView)
        activityIndicatorView.addSubview(activityIndicator)
        activityIndicatorView.addSubview(successView)
    }

    func updateAdress() {
        placeButton.repaintBorder(borderWidth: 0, color: .clear)
        placeButton.setTitle(choosedPoint.name, for: .normal)
        placeButton.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
        debugPrint(choosedPoint)
    }

    private func createDatePicker(for textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ru_RF")
        textField.inputView = datePicker
        textField.inputAccessoryView = toolbar
    }

    // MARK: - Private Methods

    func createDeniedAlertController() {
        let alert = UIAlertController(
            title: "Требуется разрешение, чтобы добавлять фото мероприятия",
            message: "Пожалуйста, включите разрешение в настройках",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)
        let settingsAction = UIAlertAction(
            title: "Настройки",
            style: .default
        ) { [weak self] _ in
            self?.openSettings()
        }
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        present(alert, animated: true)
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }

    private func setupLayout() {
        scrollView.pin.all()
        if didPhotoTakenFlag {
            print("----------1----------")
            eventImageView.pin
                .top(24)
                .height(250 * UIScreen.main.bounds.height/926)
                .width(250 * UIScreen.main.bounds.height/926)
                .hCenter()
        } else {
            print("----------2----------")
            eventImageView.pin
                .top(24)
                .height(100)
                .width(130)
                .hCenter()
        }

        eventTitleTextField.pin
            .below(of: eventImageView)
            .marginTop(24)
            .left(view.pin.safeArea.left + 20)
            .right(view.pin.safeArea.right + 20)
            .height(50)

        eventDescriptionTextView.pin
            .below(of: eventTitleTextField, aligned: .left)
            .marginTop(12)
            .width(of: eventTitleTextField)
            .height(100)

        beginDateTextField.pin
            .below(of: eventDescriptionTextView, aligned: .left)
            .marginTop(12)
            .width(eventDescriptionTextView.frame.width/2 - 10)
            .height(50)

        endDateTextField.pin
            .topRight(to: eventDescriptionTextView.anchor.bottomRight)
            .marginTop(12)
            .width(of: beginDateTextField)
            .height(50)

        separatorLabel.pin
            .hCenter()
            .below(of: eventDescriptionTextView)
            .marginTop(25)
            .sizeToFit()

        placeButton.pin
            .below(of: beginDateTextField, aligned: .left)
            .marginTop(12)
            .width(of: eventDescriptionTextView)
            .height(50)

        costTextField.pin
            .below(of: placeButton, aligned: .left)
            .marginTop(12)
            .width(of: eventTitleTextField)
            .height(50)

        contactsTextField.pin
            .below(of: costTextField, aligned: .left)
            .marginTop(12)
            .width(of: eventTitleTextField)
            .height(50)

        rubleView.pin
            .vCenter()
            .right(24)
            .width(27)
            .height(25)

        addButton.pin
            .below(of: contactsTextField, aligned: .left)
            .marginTop(24)
            .width(of: placeButton)
            .height(50)

        activityIndicatorView.pin
            .center()
            .width(100)
            .height(100)

        activityIndicator.pin.center()

        successView.pin
            .center()
            .width(70)
            .height(70)
    }
}

// MARK: - Actions

private extension AddNewEventVC {

    @objc
    func didStartEnterTitle() {
        eventTitleTextField.repaintBorder(borderWidth: 0, color: .clear)
    }

    @objc
    func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        dateFormatter.locale = Locale(identifier: "ru_RF")
        currentEditingDateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }

    // TODO: - убрать (тест бека)
    @objc
    func test(_ sender: UIButton) {
        debugPrint("--------start download--------")
        EventManager.shared.downloadEvents { result in
            switch result {
            case .success(let events):
                print(events)
                FeedbackGenerator.shared.succesFeedbackGenerator()
            case .failure(let error):
                let alertController = UIAlertController(title: nil, message: error.rawValue, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                print("ГГ")
                print("Error! \(error.localizedDescription)")
                FeedbackGenerator.shared.errorFeedbackGenerator()
            }
        }
    }

    @objc
    func didTapEventImageView(_ sender: UIButton) {
        dismissKeyboard(UITapGestureRecognizer())
        self.imagePicker?.present(from: sender)
    }

    @objc
    func didTapAddButton() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        view.isUserInteractionEnabled = false
        if costTextField.text?.isEmpty ?? false {
            costTextField.text = "0"
        }

        UIView.animate(withDuration: 0.3, delay: 0) {
            self.activityIndicatorView.alpha = 1
            self.activityIndicator.alpha = 1
        }
        activityIndicatorView.isHidden = false
        activityIndicator.startAnimating()

        guard let title = eventTitleTextField.text,
              eventTitleTextField.text != "",
              let description = eventDescriptionTextView.text,
              let begin = beginDateTextField.text,
              let end = endDateTextField.text,
              let place = choosedPoint.name,
              let latitude = choosedPoint.latitude,
              let longtitude = choosedPoint.longtitude,
              let costStr = costTextField.text,
              let contacts = contactsTextField.text,
              let cost = Int(costStr) else {

            addButton.invalidAnimation()
            if eventTitleTextField.text == "" {
                eventTitleTextField.repaintBorder()
            }
            if choosedPoint.name == nil {
                placeButton.repaintBorder()
            }

            FeedbackGenerator.shared.errorFeedbackGenerator()
            self.activityIndicatorView.isHidden = true
            self.activityIndicator.stopAnimating()
            view.isUserInteractionEnabled = true

            return
        }

        let image: UIImage? = didPhotoTakenFlag ? eventImageView.image : nil

        let docName = "\(title)-\(UUID().uuidString)"

        let event = Event(image: image, imageName: "", title: title, description: description, begin: begin, end: end, place: "\(place)|\(latitude)|\(longtitude)", cost: cost, contacts: contacts, countOfParticipants: 0, docName: docName)
        EventManager.shared.uploadEvent(event: event) { result in
            switch result {
            case .success:
                UIView.animate(withDuration: 0.3, delay: 0) {
                    self.activityIndicator.alpha = 0
                }
                UIView.animate(withDuration: 0.2, delay: 0.3) {
                    self.activityIndicator.stopAnimating()
                    self.successView.alpha = 1
                }
                UIView.animate(withDuration: 0.3, delay: 0.6) {
                    self.successView.alpha = 0
                    self.activityIndicatorView.alpha = 0
                }
                self.view.isUserInteractionEnabled = true
                FeedbackGenerator.shared.succesFeedbackGenerator()
                NotificationCenter.default.post(name: NSNotification.Name("EventManager.UploadEvent.Sirius.PartyHub"), object: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.navigation?(.registration)
                }
            case .failure(let error):
                let alertController = UIAlertController(title: nil, message: error.rawValue, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                print("ГГ")
                print("Error! \(error.localizedDescription)")
                self.activityIndicatorView.isHidden = true
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
    }

    @objc
    func choosePlace() {
        navigation?(.choosePlace)
    }

    @objc
    private func backAction() {
        navigation?(.back)
    }

    @objc
    private func registerButtonTapped() {
        navigation?(.registration)
    }

    @objc
    private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        eventTitleTextField.resignFirstResponder()
        endDateTextField.resignFirstResponder()
        beginDateTextField.resignFirstResponder()
        eventDescriptionTextView.resignFirstResponder()
        costTextField.resignFirstResponder()
        contactsTextField.resignFirstResponder()
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

// MARK: - UITextFieldDelegate
extension AddNewEventVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == beginDateTextField || textField == endDateTextField {
            return false
        } else {
            return true
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == beginDateTextField || textField == endDateTextField {
            currentEditingDateTextField = textField
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard(UITapGestureRecognizer())
        return true
    }
}

// MARK: - UITextViewDelegate
extension AddNewEventVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

// MARK: - ImagePickerDelegate
extension AddNewEventVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        didPhotoTakenFlag = true

        self.eventImageView.image = image
        viewDidLayoutSubviews()
    }
}
