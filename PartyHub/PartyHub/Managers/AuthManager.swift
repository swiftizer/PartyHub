//
//  AuthManager.swift
//  PartyHub
//
//  Created by Dinar Garaev on 19.08.2022.
//

import FirebaseAuth

protocol AuthManagerDescription {
    func currentUser() -> User?
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signOut(completion: @escaping (Result<Void, Error>) -> Void)
    func registration(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class AuthManager: AuthManagerDescription {
    static let shared: AuthManagerDescription = AuthManager()

    private init() {}

    func currentUser() -> User? {
        return Auth.auth().currentUser
    }

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

    func registration(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
