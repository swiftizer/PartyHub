//
//  Picker.swift
//  ImagePicker
//
//  Created by Сергей Николаев on 18.08.2022.
//

import UIKit
import AVFoundation

protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController: AddNewEventVC?
    private weak var delegate: ImagePickerDelegate?

    init(presentationController: AddNewEventVC, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }

    private func performAction(type: UIImagePickerController.SourceType) {
        if type == .camera {
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                // already authorized
                print("already authorized")
                self.pickerController.sourceType = type
                self.presentationController?.present(self.pickerController, animated: true)
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        // access allowed
                        print("access allowed")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.pickerController.sourceType = type
                            self.presentationController?.present(self.pickerController, animated: true)
                        }
                    } else {
                        // access denied
                        print("access denied")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.presentationController?.createDeniedAlertController()
                        }
                    }
                })
            }
        } else {
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    private func getAlertAction(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            performAction(type: type)
        }
    }

    public func presentByAlert(from sourceView: UIView) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.getAlertAction(for: .camera, title: "Камера") {
            alertController.addAction(action)
        }

        if let action = self.getAlertAction(for: .photoLibrary, title: "Галерея") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    public func createImagePickerMenu() -> UIMenu {
        let photoAction = UIAction(
            title: "Камера",
            image: UIImage(systemName: "camera")
          ) { [unowned self] (_) in
              self.performAction(type: .camera)
          }

        let albumAction = UIAction(
            title: "Галерея",
            image: UIImage(systemName: "square.stack")
        ) { [unowned self] (_) in
            self.performAction(type: .photoLibrary)
        }

        let menuActions = [photoAction, albumAction]

        let addNewMenu = UIMenu(
            title: "",
            children: menuActions)

          return addNewMenu
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}
//
