//
//  EventManager.swift
//  AddEventController
//
//  Created by Сергей Николаев on 18.08.2022.
//

import Foundation
import FirebaseFirestore

struct Event {
    var image: UIImage?
    let imageName: String
    let title: String
    let description: String
    let begin: String
    let end: String
    let place: String
    let cost: Int
    let contacts: String
    let countOfParticipants: Int
}

protocol EventManagerDescription {
    func downloadEvents(completion: @escaping (Result<[Event], NetworkError>) -> Void)
    func uploadEvent(event: Event, completion: @escaping (Result<Event, NetworkError>) -> Void)
}

final class EventManager: EventManagerDescription {

    private let database = Firestore.firestore()
    private let imageManager = ImageManager.shared

    static let shared: EventManagerDescription = EventManager()

    private init() {}

    func downloadEvents(completion: @escaping (Result<[Event], NetworkError>) -> Void) {
        database.collection("events").getDocuments { [weak self] snapshot, error in
            if let _ = error {
                completion(.failure(NetworkError.emptyData))
            } else if let events = self?.events(from: snapshot) {
                completion(.success(events))
            } else {
                fatalError()
            }
        }
    }

    func uploadEvent(event: Event, completion: @escaping (Result<Event, NetworkError>) -> Void) {
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
                    Keys.countOfParticipants.rawValue: event.countOfParticipants
                ]

                self?.database.collection("events").addDocument(data: data) { [weak self] error in
                    guard let self = self else {
                        return
                    }

                    if let _ = error {
                        completion(.failure(NetworkError.badAttempt))
                    } else {
                        if let event = self.event(from: data) {
                            completion(.success(event))
                        } else {
                            fatalError()
                        }
                    }
                }


            case .failure(_):
                completion(.failure(NetworkError.badAttempt))

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
            let countOfParticipants = data[Keys.countOfParticipants.rawValue] as? Int
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
                     countOfParticipants: countOfParticipants)
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
    }
}
