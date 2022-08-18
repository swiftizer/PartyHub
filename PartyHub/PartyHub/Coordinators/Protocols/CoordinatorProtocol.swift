//
//  CoordinatorProtocol.swift
//  PartyHub
//
//  Created by Dinar Garaev on 10.08.2022.
//

import UIKit

// MARK: - Coordinator

enum FlowResult<R> {
    case success(R)
    case failure(Error)
    case canceled
}

protocol Coordinator: Presentable {
    associatedtype Result

    var result: ((FlowResult<Result>) -> Void)? { get set }

    func start()
}
