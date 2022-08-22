//
//  CoordinatorProtocol.swift
//  PartyHub
//
//  Created by Dinar Garaev on 10.08.2022.
//

import UIKit

// MARK: - Coordinator

enum FlowResult<Void> {
    case success(Void)
    case failure(Error)
    case canceled
}

protocol Coordinator: Presentable {
    var result: ((FlowResult<Void>) -> Void)? { get set }
    func start()
}
