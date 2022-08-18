//
//  FirestoreManager.swift
//
//
//  Created by Сергей Николаев on 18.08.2022.
//

import Foundation
import FirebaseFirestore

struct User {
    var email: String
    let firstName: String
    let lastName: String
}

enum NetworkError: String, Error {
    case findError
    case invalidUrl
    case emptyData
    case badAttempt
}

protocol EventManagerDescription {
    func downloadEvents(completion: @escaping (Result<[User], NetworkError>) -> Void)
    func uploadEvent(event: User, completion: @escaping (Result<User, NetworkError>) -> Void)
}

final class EventManager: EventManagerDescription {

    private let database = Firestore.firestore()

    static let shared: EventManagerDescription = EventManager()

    private init() {}

    func downloadEvents(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        database.collection("Users").getDocuments { [weak self] snapshot, error in
            if error != nil {
                completion(.failure(NetworkError.emptyData))
            } else if let users = self?.users(from: snapshot) {
                DispatchQueue.main.async {
                    completion(.success(users))
                }
            } else {
                fatalError()
            }
        }
    }

    func uploadEvent(event: User, completion: @escaping (Result<User, NetworkError>) -> Void) {
//        guard let image = event.image else {
//            completion(.failure(NetworkError.emptyData))
//            return
//        }
    }
}

private extension EventManager {
    func users(from snapshot: QuerySnapshot?) -> [User]? {
        return snapshot?.documents.compactMap { user(from: $0.data()) }
    }

    func user(from data: [String: Any]) -> User? {
        guard
            let email = data[Keys.email.rawValue] as? String,
            let firstName = data[Keys.firstName.rawValue] as? String,
            let lastName = data[Keys.lastName.rawValue] as? String
        else { return nil }

        return User(email: email, firstName: firstName, lastName: lastName)
    }

    enum Keys: String {
        case email
        case firstName
        case lastName
    }
}
