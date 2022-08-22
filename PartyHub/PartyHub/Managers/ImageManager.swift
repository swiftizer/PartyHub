//
//  ImageManager.swift
//  AddEventController
//
//  Created by Сергей Николаев on 18.08.2022.
//

import FirebaseStorage
import UIKit
import Kingfisher

protocol ImageManagerDescription {
    func uploadImage(image: UIImage?, completion: @escaping (Result<String, NetworkError>) -> Void)
    func downloadImage(with name: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void)
    func deleteImage(imageName: String, completion: @escaping (Result<String, NetworkError>) -> Void)
}

final class ImageManager: ImageManagerDescription {
    static let shared: ImageManagerDescription = ImageManager()

    private let storageRef = Storage.storage().reference()
    private let cache = ImageCache.default

    private init() {}

    func uploadImage(image: UIImage?, completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard let img = image else {
            completion(.success("default.jpeg"))
            return
        }

        guard let data = img.jpegData(compressionQuality: 0.5) else {
            fatalError()
        }

        let imageName = UUID().uuidString + ".jpeg"

        storageRef.child(imageName).putData(data) { _, error in
            if let error = error {
                debugPrint(error)
                completion(.failure(NetworkError.badAttempt))
            } else {
                completion(.success(imageName))
            }
        }
    }

    func downloadImage(with name: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        cache.retrieveImage(forKey: name) { [weak self] result in
            switch result {
            case .success(let imageResult):
                if let image = imageResult.image {
                    completion(.success(image))
                } else {
                    self?.downloadImageFromFirebase(imageName: name, completion: completion)
                }
            case .failure:
                self?.downloadImageFromFirebase(imageName: name, completion: completion)
            }
        }
    }

    func deleteImage(imageName: String, completion: @escaping (Result<String, NetworkError>) -> Void) {

        storageRef.child(imageName).delete { error in
            if let error = error {
                completion(.failure(NetworkError.badAttempt))
            } else {
                self.cache.removeImage(forKey: imageName)
                completion(.success(imageName))
            }
        }
    }

    private func downloadImageFromFirebase(
        imageName: String,
        completion: @escaping (Result<UIImage, NetworkError>) -> Void
    ) {
        storageRef.child(imageName).getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
            if let error = error {
                debugPrint(error)
                completion(.failure(NetworkError.badAttempt))
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NetworkError.badAttempt))
                return
            }

            self?.cache.store(image, forKey: imageName)
            completion(.success(image))
        }
    }
}
