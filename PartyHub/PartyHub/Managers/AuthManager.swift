//
//  AuthManager.swift
//  PartyHub
//
//  Created by Dinar Garaev on 19.08.2022.
//

import FirebaseAuth
import UIKit

protocol AuthManagerDescription {
    func currentUser() -> User?
    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signOut(completion: @escaping (Result<Void, Error>) -> Void)
    func registration(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    var adminUid: String { get }
}

final class AuthManager: AuthManagerDescription {
    static let shared: AuthManagerDescription = AuthManager()
    let adminUid = "cESqBYViFph8WnMKVk03PpFi1Ni1"

    private init() {}

    func currentUser() -> User? {
        return Auth.auth().currentUser
    }

    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        currentUser()?.delete { error in
            if let error = error {
                completion(.failure(error))

          } else {
              completion(.success(()))
          }
        }
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
