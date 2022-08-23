//
//  EventModel.swift
//  PartyHub
//
//  Created by Dinar Garaev on 22.08.2022.
//

import UIKit

struct Event: Equatable {
    var image: UIImage?
    let imageName: String
    let title: String
    let description: String
    let begin: String
    let end: String
    let place: String
    let cost: Int
    let contacts: String
    var countOfParticipants: Int
    let docName: String
}
