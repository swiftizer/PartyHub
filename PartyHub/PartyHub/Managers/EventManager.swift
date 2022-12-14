//
//  EventManager.swift
//  AddEventController
//
//  Created by Сергей Николаев on 18.08.2022.
//

import Foundation
import FirebaseFirestore

protocol EventManagerDescription {
    func downloadEvents(completion: @escaping (Result<[Event], NetworkError>) -> Void)
    func downloadFollowedEvents(completion: @escaping (Result<[Event], NetworkError>) -> Void)
    func isEventFollowedByUser(event: Event, completion: @escaping (Result<Bool, NetworkError>) -> Void)
    func updateParticipantsCount(for event: Event, to value: Int, completion: @escaping (Result<Int, NetworkError>) -> Void)
    func downloadCreatedEvents(completion: @escaping (Result<[Event], NetworkError>) -> Void)
    func goToEvent(event: Event, completion: @escaping (Result<Event, NetworkError>) -> Void)
    func cancelGoToEvent(event: Event, completion: @escaping (Result<Event, NetworkError>) -> Void)
    func uploadEvent(event: Event, completion: @escaping (Result<Event, NetworkError>) -> Void)
    func deleteEvent(event: Event, completion: @escaping (Result<Void, NetworkError>) -> Void)
    func deleteCreatedEventsByUser(completion: @escaping (Result<Void, NetworkError>) -> Void)
    func adminDeleteEvent(event: Event, completion: @escaping (Result<Event, NetworkError>) -> Void)
    func initUserStructure(completion: @escaping (Result<String, NetworkError>) -> Void)
}

final class EventManager: EventManagerDescription {
    private let database = Firestore.firestore()
    private let imageManager = ImageManager.shared

    static let shared: EventManagerDescription = EventManager()

    private init() {}

    func downloadEvents(completion: @escaping (Result<[Event], NetworkError>) -> Void) {
        database.collection("events").getDocuments { [weak self] snapshot, error in
            if error != nil {
                completion(.failure(NetworkError.emptyData))
            } else if let events = self?.events(from: snapshot) {
                completion(.success(events))
            } else {
                fatalError()
            }
        }
    }

    func updateParticipantsCount(for event: Event, to value: Int, completion: @escaping (Result<Int, NetworkError>) -> Void) {
        database.collection("events").document(event.docName).updateData(["countOfParticipants": value]) { err in
            if err != nil {
                completion(.failure(NetworkError.badAttempt))
            } else {
                completion(.success(value))
            }
        }
    }

    func isEventFollowedByUser(event: Event, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard AuthManager.shared.currentUser()?.uid != nil else {
            completion(.success(false)) // TODO: - тут точно .success(false)?
            return
        }

        downloadEventIDsForUser { result in
            switch result {
            case .success(let docs):
                if docs.followed.contains(event.docName) {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            case .failure:
                completion(.failure(NetworkError.badAttempt))
            }
        }
    }

    func deleteCreatedEventsByUser(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        guard AuthManager.shared.currentUser()?.uid != nil else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        downloadEventIDsForUser { [weak self] result in
            switch result {
            case .success(let docs):
                if docs.created.count == 0 {
                    completion(.success(()))
                    return
                }
//                var events = [Event]()

                let group = DispatchGroup()
                for doc in docs.created {
                    group.enter()
                    self?.database.collection("events").document(doc).getDocument { document, error in
                        guard let data = document?.data() else {
                            completion(.failure(NetworkError.emptyData))
                            return
                        }
                        if error != nil {
                            completion(.failure(NetworkError.emptyData))
                        } else if let event = self?.event(from: data) {
//                            events.append(event)
                            self?.deleteEvent(event: event) { res in
                                switch res {
                                case .success:
                                    group.leave()
                                case .failure:
                                    completion(.failure(NetworkError.emptyData))
                                }
                            }
                        } else {
                            fatalError()
                        }
                    }
                }

                group.notify(queue: DispatchQueue.main) {
                    completion(.success(()))
                }

            case .failure:
                completion(.failure(NetworkError.badAttempt))
            }
        }
    }

    private func downloadEventIDsForUser(completion: @escaping (Result<DocIDs, NetworkError>) -> Void) {
        guard let userID = AuthManager.shared.currentUser()?.uid else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        database.collection("\(userID)").document("userData").getDocument { document, error in
            if error != nil {
                completion(.failure(NetworkError.emptyData))
            } else if let docs = self.getDocIDs(from: (document?.data())!) {
                completion(.success(docs))
            } else {
                fatalError()
            }
        }
    }

    func downloadFollowedEvents(completion: @escaping (Result<[Event], NetworkError>) -> Void) {
        guard AuthManager.shared.currentUser()?.uid != nil else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        downloadEventIDsForUser { [weak self] result in
            switch result {
            case .success(let docs):
                if docs.followed.count == 0 {
                    completion(.success([]))
                    return
                }
                var events = [Event]()

                let group = DispatchGroup()
                for doc in docs.followed {
                    group.enter()
                    self?.database.collection("events").document(doc).getDocument { document, error in
                        guard document?.data() != nil else {
                            group.leave()
                            return
                        }
                        if error != nil {
                            completion(.failure(NetworkError.emptyData))
                        } else if let event = self?.event(from: (document?.data())!) {
                            events.append(event)
                            group.leave()
                        } else {
                            fatalError()
                        }
                    }
                }

                group.notify(queue: DispatchQueue.main) {
                    completion(.success(events))
                }

            case .failure:
                completion(.failure(NetworkError.badAttempt))
            }
        }
    }

    func downloadCreatedEvents(completion: @escaping (Result<[Event], NetworkError>) -> Void) {
        guard AuthManager.shared.currentUser()?.uid != nil else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        downloadEventIDsForUser { [weak self] result in
            switch result {
            case .success(let docs):
                if docs.created.count == 0 {
                    completion(.success([]))
                    return
                }
                var events = [Event]()

                let group = DispatchGroup()
                for doc in docs.created {
                    group.enter()
                    self?.database.collection("events").document(doc).getDocument { document, error in
                        guard let data = document?.data() else {
                            group.leave()
                            return
                        }
                        if error != nil {
                            completion(.failure(NetworkError.emptyData))
                        } else if let event = self?.event(from: data) {
                            events.append(event)
                            group.leave()
                        } else {
                            fatalError()
                        }
                    }
                }

                group.notify(queue: DispatchQueue.main) {
                    completion(.success(events))
                }

            case .failure:
                completion(.failure(NetworkError.badAttempt))
            }
        }
    }

    func goToEvent(event: Event, completion: @escaping (Result<Event, NetworkError>) -> Void) {
        guard let userID = AuthManager.shared.currentUser()?.uid else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        database.collection("\(userID)").document("userData").updateData(["followed": FieldValue.arrayUnion([event.docName])]) { error in
            if error != nil {
                self.database.collection("\(userID)").document("userData").setData(["followed": [event.docName]]) { error in
                    if error != nil {
                        completion(.failure(NetworkError.badAttempt))
                    } else {
                        completion(.success(event))
                    }
                }
            } else {
                completion(.success(event))
            }
        }
    }

    func cancelGoToEvent(event: Event, completion: @escaping (Result<Event, NetworkError>) -> Void) {
        guard let userID = AuthManager.shared.currentUser()?.uid else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        database.collection("\(userID)").document("userData").updateData(["followed": FieldValue.arrayRemove([event.docName])]) { error in
            if error != nil {
                completion(.failure(NetworkError.badAttempt))
            } else {
                completion(.success(event))
            }
        }
    }

    func uploadEvent(event: Event, completion: @escaping (Result<Event, NetworkError>) -> Void) {
        let group = DispatchGroup()

        guard let userID = AuthManager.shared.currentUser()?.uid else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        group.enter()
        imageManager.uploadImage(image: event.image) { [weak self] result in
            switch result {
            case .success(let uploadedImageName):
                let data: [String: Any] = [
                    Keys.imageName.rawValue: uploadedImageName,
                    Keys.title.rawValue: event.title,
                    Keys.description.rawValue: event.description,
                    Keys.begin.rawValue: event.begin,
                    Keys.end.rawValue: event.end,
                    Keys.place.rawValue: event.place,
                    Keys.cost.rawValue: event.cost,
                    Keys.contacts.rawValue: event.contacts,
                    Keys.countOfParticipants.rawValue: event.countOfParticipants,
                    Keys.docName.rawValue: event.docName
                ]

                self?.database.collection("events").document(event.docName).setData(data) { [weak self] error in
                    guard let self = self else {
                        return
                    }

                    if error != nil {
                        completion(.failure(NetworkError.badAttempt))
                    } else {
                        if self.event(from: data) != nil {
                            group.leave()
                        } else {
                            completion(.failure(NetworkError.badAttempt))
                            fatalError()
                        }
                    }
                }

            case .failure:
                completion(.failure(NetworkError.badAttempt))
            }
        }

        group.enter()

        database.collection("\(userID)").document("userData").updateData(["created": FieldValue.arrayUnion([event.docName])]) { error in
            if error != nil {
                self.database.collection("\(userID)").document("userData").setData(["created": [event.docName]]) { error in

                    if error != nil {
                        completion(.failure(NetworkError.badAttempt))
                    } else {
                        group.leave()
                    }
                }
            } else {
                group.leave()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            completion(.success(event))
        }
    }

    func initUserStructure(completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard let userID = AuthManager.shared.currentUser()?.uid else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        database.collection("\(userID)").document("userData").setData(["created": [], "followed": []]) { error in
            if error != nil {
                completion(.failure(NetworkError.badAttempt))
            } else {
                completion(.success(userID))
            }
        }
    }

    func deleteEvent(event: Event, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        guard let userID = AuthManager.shared.currentUser()?.uid else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

        let group = DispatchGroup()

        group.enter()
        database.collection("\(userID)").document("userData").updateData(["created": FieldValue.arrayRemove([event.docName])]) { error in
            if error != nil {
                completion(.failure(NetworkError.badAttempt))
            } else {
                group.leave()
            }
        }

        group.enter()
        database.collection("events").document(event.docName).delete { error in
            if  error != nil {
                completion(.failure(NetworkError.badAttempt))
            } else {
                if event.imageName == "default.jpeg" {
                    group.leave()
                } else {
                    self.imageManager.deleteImage(imageName: event.imageName) { result in
                        switch result {
                        case .success:
                            group.leave()
                        case .failure:
                            completion(.failure(NetworkError.badAttempt))
                        }
                    }
                }
            }
        }

        group.notify(queue: DispatchQueue.main) {
            completion(.success(()))
        }
    }

    func adminDeleteEvent(event: Event, completion: @escaping (Result<Event, NetworkError>) -> Void) {
        database.collection("events").document(event.docName).delete { err in
            if err != nil {
                completion(.failure(NetworkError.badAttempt))
            } else {
                if event.imageName == "default.jpeg" {
                    completion(.success(event))
                } else {
                    self.imageManager.deleteImage(imageName: event.imageName) { result in
                        switch result {
                        case .success:
                            completion(.success(event))

                        case .failure:
                            completion(.failure(NetworkError.badAttempt))
                        }
                    }
                }
            }
        }
    }
}

private extension EventManager {
    func events(from snapshot: QuerySnapshot?) -> [Event]? {
        return snapshot?.documents.compactMap { event(from: $0.data()) }
    }

    func event(from data: [String: Any]) -> Event? {
        guard
            let imageName = data[Keys.imageName.rawValue] as? String,
            let title = data[Keys.title.rawValue] as? String,
            let description = data[Keys.description.rawValue] as? String,
            let begin = data[Keys.begin.rawValue] as? String,
            let end = data[Keys.end.rawValue] as? String,
            let place = data[Keys.place.rawValue] as? String,
            let cost = data[Keys.cost.rawValue] as? Int,
            let contacts = data[Keys.contacts.rawValue] as? String,
            let countOfParticipants = data[Keys.countOfParticipants.rawValue] as? Int,
            let docName = data[Keys.docName.rawValue] as? String
        else {
            return nil
        }

        return Event(image: nil,
                     imageName: imageName,
                     title: title,
                     description: description,
                     begin: begin,
                     end: end,
                     place: place,
                     cost: cost,
                     contacts: contacts,
                     countOfParticipants: countOfParticipants,
                     docName: docName)
    }

    enum Keys: String {
        case imageName
        case title
        case description
        case begin
        case end
        case place
        case cost
        case contacts
        case countOfParticipants
        case docName
    }

    func getDocIDs(from data: [String: Any]) -> DocIDs? {
        guard let created = data[Keys2.created.rawValue] as? [String],
              let followed = data[Keys2.followed.rawValue] as? [String]
        else {
            return nil
        }

        return DocIDs(created: created, followed: followed)
    }

    enum Keys2: String {
        case created
        case followed
    }
}
